<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="pelmanism[not(@max_score='')]" mode="teacherPointsCalculation">
		<value><xsl:value-of select="@max_score"/></value>
	</xsl:template>

</xsl:stylesheet>
