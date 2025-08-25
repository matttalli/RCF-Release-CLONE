<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="itemCheckbox[not(@example='y') and not(@marked='n') and @mark='item']" mode="itemBasedPointsCalculation">
		<value><xsl:value-of select="count(item[@correct='y' and not(@example='y')])"/></value>
	</xsl:template>

	<xsl:template match="itemCheckbox[not(@example='y') and not(@marked='n') and (@mark='list' or @mark='' or not(@mark)) and count(item[@correct='y' and not(@example='y')]) &gt; 0]" mode="itemBasedPointsCalculation">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
