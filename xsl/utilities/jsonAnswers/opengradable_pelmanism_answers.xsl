<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="pelmanism" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "unmarked",
			"markedBy": "nobody",
			"type": "composite",
			"ignoreNextAnswer": "y",
			<xsl:call-template name="maxScore"/>
			"value": [
				{
					"elm": "tries",
					"type": "simple",
					"value": ""
				},
				{
					"elm": "timetaken",
					"type": "simple",
					"value": ""
				}
			]
		}
	</xsl:template>

</xsl:stylesheet>
