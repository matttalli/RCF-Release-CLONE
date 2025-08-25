<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
	TODO:

	Still need to decide how this will be used - the game will be responsible for the marking - I guess the gradebook would want
	a list of words / ids and whether the user got them correct or not, but that can be decided later on.

-->
	<xsl:template match="spellingBee" mode="outputAnswers">
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
