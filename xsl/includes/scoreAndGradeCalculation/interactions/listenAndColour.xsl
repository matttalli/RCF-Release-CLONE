<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="listenAndColour" mode="pointsCalculation">
		<value><xsl:value-of select="count(itemGroups/items[not(@distractor='y') and not(count(item[@example='y']) = count(item))])"/></value>
	</xsl:template>

	<xsl:template match="listendAndColour" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
