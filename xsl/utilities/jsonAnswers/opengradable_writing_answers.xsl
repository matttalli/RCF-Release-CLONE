<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="writing" mode="outputAnswers">
		<xsl:variable name="maxScore">
			<xsl:choose>
				<xsl:when test="@max_score and @max_score!=''">
					<xsl:value-of select="@max_score"/>
				</xsl:when>
				<xsl:otherwise>5</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "feedback",
			"markedBy": "teacher",
			"ignoreNextAnswer": "y",
			"type": "openGradable_writing",
			"max_score": <xsl:value-of select="$maxScore"/>,
			"value": ""
		}
	</xsl:template>

</xsl:stylesheet>
