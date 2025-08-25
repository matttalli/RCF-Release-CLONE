<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="itemDropDown[item/@correct='y' and not(@example='y') and not(@marked='n')]" mode="itemBasedPointsCalculation">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
