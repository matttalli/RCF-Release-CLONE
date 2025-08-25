<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexCategorise[not(@marked='n')]" mode="pointsCalculation">
		<value><xsl:value-of select="count(categories/category/item[not(@example='y')])"/></value>
	</xsl:template>

	<xsl:template match="complexCategorise" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
