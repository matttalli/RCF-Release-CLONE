<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="complexDroppable[not(@example='y')]" mode="outputAnswers">
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
				<xsl:when test="count(item)>1">choice</xsl:when>
				<xsl:otherwise>simple</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "<xsl:value-of select="$jsonType"/>",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value":
				<xsl:choose>
					<xsl:when test="$jsonType='simple'">"<xsl:value-of select="item/@id"/>"</xsl:when>
					<xsl:otherwise>
					[
						<xsl:for-each select="item">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
					]
					</xsl:otherwise>
				</xsl:choose>
		}
	</xsl:template>

	<xsl:template match="itemComplexDroppableBlock" mode="outputAnswers">
		,{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "composite",
			"markType": "item",
			"markedBy": "engine",
			"value": [
				<xsl:for-each select=".//itemComplexDroppable[not(@example='y')]">
					{
						"elm": "<xsl:value-of select="@id"/>",
						"type": "choice",
						"markedBy": "engine",
						"markType": "item",
						"value": [
							<xsl:for-each select="item">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
						]
					}
					<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
	</xsl:template>

</xsl:stylesheet>