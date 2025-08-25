<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="locating[not(@example='y') and not(@marked='n') and not(@distractor='y')]" mode="pointsCalculation">
		<value>1</value>
	</xsl:template>

	<xsl:template match="locating[not(@example='y') and not(@marked='n')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
