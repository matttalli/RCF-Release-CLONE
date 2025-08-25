<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="pelmanism" mode="outputAnswers">
		<xsl:variable name="numPairs">
			<xsl:choose>
				<xsl:when test="@numPairs"><xsl:value-of select="@numPairs"/></xsl:when>
				<xsl:otherwise>6</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "unmarked",
			"markedBy": "nobody",
			"type": "game_pelmanism",
			"ignoreNextAnswer": "y",
			"value": {
				"completion": "",
				"tries": "",
				"correct": "",
				"outOf": "<xsl:value-of select="$numPairs"/>",
				"timeTaken": "",
				"pairs": []
			}
		}
	</xsl:template>

</xsl:stylesheet>
