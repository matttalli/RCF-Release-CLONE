<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text"/>
	<xsl:include href="./includes/scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl"/>

	<xsl:template match="activity">
		<xsl:call-template name="getActivityGradableType"/>
	</xsl:template>
</xsl:stylesheet>
