<?xml version="1.0" encoding="UTF-8"?>
<!--

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" indent="no" />

	<xsl:include href="../includes/inc_utils.xsl"/>
	<xsl:include href="../includes/scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl" />
	<xsl:include href="../includes/activityModeCalculation/inc_rcf_activity_mode_calculation.xsl"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="referenceContent">
		<xsl:variable name="referenceContentTitle">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="pText">
					<xsl:apply-templates select="metadata" mode="getReferenceContentTitle"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		{
			"id": "<xsl:value-of select="@id"/>",
			<!-- used by the viewer -->
			"pointsAvailable": "0",
			"teacherPointsAvailable": "0",
			"availablePoints": "0",
			"activityMode": "",

			<!-- these are used by the viewer *and* the playlist manifest / adapter -->
			"title": "<xsl:value-of select="$referenceContentTitle"/>",
			<xsl:if test="metadata/title/@lang and not(metadata/title/@lang='')">
			"titleLang": "<xsl:value-of select="metadata/title/@lang"/>",
			</xsl:if>
			"type": [
				<xsl:for-each select="metadata/type/content">
					"<xsl:value-of select="@type"/>"
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			],
			"recallable": "<xsl:value-of select="metadata/recallable/@value"/>"
		}

	</xsl:template>

	<xsl:template match="referenceContent/metadata/title" mode="getReferenceContentTitle">
		<xsl:apply-templates mode="getReferenceContentTitle"/>
	</xsl:template>

	<xsl:template match="text()" mode="getReferenceContentTitle">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>
