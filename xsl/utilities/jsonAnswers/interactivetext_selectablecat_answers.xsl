<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="interactiveTextBlock[not(@example='y') and (@type='selectableCatWords' or @type='selectableCat')]" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "composite",
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">
			"markType": "unmarked",
			"markedBy": "nobody",
				</xsl:when>
				<xsl:otherwise>
			"markType": "item",
			"markedBy": "engine",
				</xsl:otherwise>
			</xsl:choose>
			"value": [
				<xsl:for-each select=".//eSpan[not(@example='y') and not(@distractor='y')]">
				{
					"elm": "<xsl:value-of select="@id"/>",
					"type": "simple",
					"value": "<xsl:value-of select="@cat"/>"
				}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
		<xsl:apply-templates mode="outputAnswers"/>
	</xsl:template>

</xsl:stylesheet>
