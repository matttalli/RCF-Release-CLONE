<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="textInput[not(@max_score='')]" mode="teacherPointsCalculation">
		<value><xsl:value-of select="@max_score"/></value>
	</xsl:template>

	<xsl:template match="textInput[not(@max_score)]" mode="teacherPointsCalculation">
		<value>0</value>
	</xsl:template>

	<xsl:template match="textInput" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
