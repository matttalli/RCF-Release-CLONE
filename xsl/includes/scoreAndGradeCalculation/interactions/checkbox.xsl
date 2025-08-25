<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="checkbox[not(@mark='list') and not(@example='y') and not(@marked='n')]" mode="pointsCalculation">
		<value><xsl:value-of select="count(item[@correct='y' and not(@example='y')])"/></value>
	</xsl:template>

	<xsl:template match="checkbox[@mark='list' and not(@example='y') and not(@marked='n') and count(item[@correct='y' and not(@example='y')]) &gt; 0]" mode="pointsCalculation">
		<value>1</value>
	</xsl:template>

	<xsl:template match="checkbox[not(@example='y')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
