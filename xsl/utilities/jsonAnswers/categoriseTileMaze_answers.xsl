<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="categoriseTileMaze" mode="outputAnswers">
		<xsl:variable name="outOf">
			<xsl:choose>
				<xsl:when test="@show"><xsl:value-of select="@show"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "unmarked",
			"markedBy": "nobody",
			"type": "game_categoriseTileMaze",
			"ignoreNextAnswer": "y",
			"value": {
				"completion": "",
				"livesLeft": "",
				"correct": "",
				"outOf": "<xsl:value-of select="$outOf"/>",
				"timeTaken": ""
			}
		}
	</xsl:template>

</xsl:stylesheet>
