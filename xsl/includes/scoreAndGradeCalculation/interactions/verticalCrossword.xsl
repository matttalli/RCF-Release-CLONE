<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="verticalCrossword[not(@example='y') and not(@marked='n')]" mode="pointsCalculation">
		<value><xsl:value-of select="count(word[not(@example='y')])"/></value>
	</xsl:template>

	<xsl:template match="verticalCrossword[not(@example='y')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
