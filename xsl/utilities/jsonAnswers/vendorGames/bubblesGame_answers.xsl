<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="bubblesGame" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "unmarked",
			"markedBy": "nobody",
			"type": "vendorGame",
			"ignoreNextAnswer": "y",
			"value": {
				"completion": "",
				"livesLeft": "",
				"totalItemsFound": "",
				"correct": "",
				"timeTaken": ""
			}
		}
	</xsl:template>

</xsl:stylesheet>
