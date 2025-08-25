<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- points calculations - where @play is populated, use that for one calculation -->
	<xsl:template match="findInImage[not(@play='')]" mode="pointsCalculation">
		<value><xsl:value-of select="@play"/></value>
	</xsl:template>

	<!-- where @play is not specified, count the number of questions -->
	<xsl:template match="findInImage[not(@play)]" mode="pointsCalculation">
		<value><xsl:value-of select="count(questions/question)"/></value>
	</xsl:template>

	<xsl:template match="findInImage" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
