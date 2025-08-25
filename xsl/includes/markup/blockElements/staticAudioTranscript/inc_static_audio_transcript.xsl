<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="staticAudioTranscript" >
		<!-- ignored for standard output -->
	</xsl:template>

	<xsl:template match="staticAudioTranscript" mode="getUnmarkedInteractionName">
		rcfStaticAudioTranscript
	</xsl:template>

	<!--

	we will only output this for print output, so something like :

	<xsl:template match="staticAudioTranscript" mode="printOutput">
		<xsl:apply-templates/>
	</xsl:template>

	-->

</xsl:stylesheet>
