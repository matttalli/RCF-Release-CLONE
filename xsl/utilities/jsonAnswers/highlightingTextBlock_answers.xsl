<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
>

	<!--
		highlighting text block interaction answers object structure

		Interaction is NOT marked, but we want to record any inputs from the user so they can be
		retrieved or populated later on

		The answers will be saved as base64 encoded strings (helps avoid dodgy html !)
	-->
	<xsl:template match="highlightingTextBlock" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "unmarked",
			"markedBy": "nobody",
			"ignoreNextAnswer": "y",
			"type": "simple",
			"value": ""
		}

	</xsl:template>

</xsl:stylesheet>
