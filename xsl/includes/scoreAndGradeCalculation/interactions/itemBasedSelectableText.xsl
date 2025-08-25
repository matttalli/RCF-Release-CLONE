<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="itemSelectableText[not(@example='y') and not(@marked='n') and @mark='list' and count(.//eSpan[@correct='y' and not(@example='y')]) &gt;0 ]" mode="itemBasedPointsCalculation">
		<value>1</value>
		<xsl:apply-templates mode="itemBasedPointsCalculation"/>
	</xsl:template>

	<xsl:template match="itemSelectableText[not(@example='y') and not(@marked='n') and not(@mark='list')]" mode="itemBasedPointsCalculation">
		<value><xsl:value-of select="count(.//eSpan[@correct='y' and not(@example='y')])"/></value>
		<xsl:apply-templates mode="itemBasedPointsCalculation"/>
	</xsl:template>


</xsl:stylesheet>
