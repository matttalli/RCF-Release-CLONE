<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		complex ordering cannot be marked as item!
	-->
	<xsl:template match="complexOrdering[not(@mark='item') and not(@example='y') and not(@marked='n')]" mode="pointsCalculation">
		<value>1</value>
	</xsl:template>

	<xsl:template match="complexOrdering[not(@example='y')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
