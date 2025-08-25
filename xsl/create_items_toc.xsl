<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- used by the viewer for the *itemBased* items xml display inside the viewer -->
	<xsl:output method="text" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		[<xsl:apply-templates/>]
	</xsl:template>

	<xsl:template match="item">
		{
			"id": "<xsl:value-of select="@id"/>"
		}<xsl:if test="count(following-sibling::*)>0">,</xsl:if>
	</xsl:template>

</xsl:stylesheet>
