<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="listenAndColour" mode="outputAnswers">
		<xsl:variable name="markType">item</xsl:variable>
		<xsl:variable name="markedBy">engine</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "composite",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": [
			<xsl:for-each select="itemGroups/items[count(item[not(@example='y')])>0 and (not(@distractor='y'))]">{
				"elm": "<xsl:value-of select="@correctColour"/>",
				"type": "list",
				"markType": "list",
				"markedBy": "engine",
				"value": [
				<xsl:for-each select="item[not(@example='y')]">
					"<xsl:value-of select="@name"/>"<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
				]
				}
				<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]

		}
	</xsl:template>

	<xsl:template match="listenAndColour" mode="detectInvalidAnswers">
		<xsl:for-each select="itemGroups/items//item">
			<xsl:if test="contains(@name, &quot;'&quot;)">
				,{ "error": "ERROR ! item id contains a quote character ! this can lead to issues in the html and javascript" }
			</xsl:if>
			<xsl:if test="contains(@name, '&quot;')">
				,{ "error": "ERROR ! item id contains a double quote character ! this can lead to issues in the html and javascript" }
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>
