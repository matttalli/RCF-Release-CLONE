<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="writing[not(@max_score='')]" mode="teacherPointsCalculation">
		<value><xsl:value-of select="@max_score"/></value>
	</xsl:template>

	<!-- RCF-10250 - writing without 'max_score' should default to 5 -->
	<xsl:template match="writing[not(@max_score)]" mode="teacherPointsCalculation">
		<value>5</value>
	</xsl:template>

	<xsl:template match="writing" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
