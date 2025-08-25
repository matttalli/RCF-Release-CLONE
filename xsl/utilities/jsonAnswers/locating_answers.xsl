<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="locating[not(@example='y') and not(@distractor='y')]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="(count(dropDown)>0 and count(dropDown/item[@correct='y'])=0) or (count(typein)>0 and count(typein/acceptable/item)=0) or @marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
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
				<xsl:when test="count(dropDown)>0">simple</xsl:when>
				<xsl:when test="count(typein[@expandAnswers='y'])>0 and(contains(typein/acceptable/item[1],'{'))">choice</xsl:when>
				<xsl:when test="count(typein[@expandAnswers='y'])>0">simple</xsl:when>
				<xsl:when test="count(typein)>0 and count(typein/acceptable/item)=1">simple</xsl:when>

				<xsl:when test="count(typein/acceptable/item)>1">choice</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm" : "<xsl:value-of select="@id"/>",
			"type" : "<xsl:value-of select="$jsonType"/>",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			<xsl:if test="count(typein[@caseSensitive='n'])>0">
			"caseSensitive": "n",
			</xsl:if>
			"value":
			<xsl:choose>
				<xsl:when test="count(dropDown)>0">
					"<xsl:value-of select="dropDown/item[@correct='y']/@id"/>"
				</xsl:when>
				<xsl:when test="count(typein)>0 and (typein[@expandAnswers='y'])">
					<xsl:variable name="answers"><xsl:for-each select="typein/acceptable/item"><xsl:call-template name="expandAnswers">
					<xsl:with-param name="stringVal"><xsl:value-of select="."/></xsl:with-param></xsl:call-template><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each></xsl:variable>
					<xsl:choose>
						<xsl:when test="count(str:tokenize($answers, '|'))>1">
							[
								<xsl:for-each select="str:tokenize($answers, '|')">
									<xsl:value-of select="."/><xsl:if test="position()!=last()">,</xsl:if>
								</xsl:for-each>
							]
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($answers, 1, string-length($answers))"/>
						</xsl:otherwise>
					 </xsl:choose>
				</xsl:when>
				<xsl:when test="count(typein)>0 and count(typein/acceptable/item)=1">
					"<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="typein/acceptable/item"/></xsl:call-template>"
				</xsl:when>
				<xsl:when test="count(typein)>0 and count(typein/acceptable/item)>1">
					[
					<xsl:for-each select="typein/acceptable/item">
						"<xsl:call-template name="escapeQuote"/>"<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					]
				</xsl:when>
			</xsl:choose>
		}
	</xsl:template>


	<xsl:template match="locating[@distractor='y']" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "simple",
			"markType": "distractor",
			"markedBy": "engine",
			"value": ""
		}
	</xsl:template>


</xsl:stylesheet>