<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="canDo" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "composite",
			"markType": "unmarked",
			"markedBy": "nobody",
			"ignoreNextAnswer": "y",
			"value": ""
		}
	</xsl:template>

</xsl:stylesheet>
