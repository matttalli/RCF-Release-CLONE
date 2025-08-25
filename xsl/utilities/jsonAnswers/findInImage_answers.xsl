<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="findInImage" mode="outputAnswers">
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
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "composite",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"ignoreNextAnswer": "y",
			"value": [
				<xsl:for-each select="questions/question">{
					"elm": "<xsl:value-of select="@id"/>",
					"type": "list",
					"markType": "list",
					"markedBy": "<xsl:value-of select="$markedBy"/>",
					"value": [
						<xsl:for-each select="item">
							"<xsl:value-of select="@id"/>"
							<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>
					]
				}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}

	</xsl:template>

	<xsl:template match="findInImage" mode="detectInvalidAnswers">
		<xsl:for-each select="items/item">
			<xsl:if test="contains(@id, &quot;'&quot;)">
				,{ "error": "ERROR ! item id contains a quote character ! this can lead to issues in the html and javascript" }
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
