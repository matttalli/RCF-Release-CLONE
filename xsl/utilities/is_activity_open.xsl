<?xml version="1.0" encoding="UTF-8"?>
<!--
	is_activity_open.xsl

	@author Chris Eastwood

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xslt="http://xml.apache.org/xslt"
	version="1.0">

	<xsl:output method="text" indent="no" />
	<xsl:include href="../includes/scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl" />
	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:call-template name="getActivityGradableType">
			<xsl:with-param name="activityNode" select="//activity"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
