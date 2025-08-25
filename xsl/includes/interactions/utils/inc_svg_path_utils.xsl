<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="getSvgLocation">
		<xsl:param name="env" />
		<xsl:param name="svgHost"/>
		<xsl:param name="svgPath"/>
		<xsl:param name="svgName"/>
		<xsl:choose>
			<xsl:when test="not($env='capePreview')"><xsl:value-of select="concat('file://', $svgPath, '/', $svgName)"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat($svgHost, $svgName)"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
