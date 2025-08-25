<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="itemTypein[not(@example='y') and not(@marked='n') and not(ancestor::itemTypeinGroup)]" mode="itemBasedPointsCalculation">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
