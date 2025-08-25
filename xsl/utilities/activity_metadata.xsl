<?xml version="1.0" encoding="UTF-8"?>
<!--

	activity_metadata.xsl

	@author Chris Eastwood


-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xslt="http://xml.apache.org/xslt"
	version="1.0">

	<xsl:output method="text" indent="no" />

	<xsl:include href="../includes/inc_utils.xsl"/>
	<xsl:include href="../includes/scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl" />
	<xsl:include href="../includes/activityModeCalculation/inc_rcf_activity_mode_calculation.xsl"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="activity">
		<xsl:variable name="activityGradableType">
			<xsl:call-template name="getActivityGradableType">
				<xsl:with-param name="activityNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="activityPointsAvailable">
			<xsl:call-template name="getActivityPointsForGradableType">
				<xsl:with-param name="activityNode" select="."/>
				<xsl:with-param name="gradableType" select="$activityGradableType"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="teacherPointsAvailable">
			<xsl:call-template name="teacherPointsAvailable">
				<xsl:with-param name="activityNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="activityMode">
			<xsl:variable name="detectedMode"><xsl:apply-templates select="." mode="getActivityMode"/></xsl:variable>
			<xsl:value-of select="normalize-space($detectedMode)"/>
		</xsl:variable>

		<xsl:variable name="itemSets">
			<xsl:apply-templates select="itemBased" mode="buildItemSetsMetadata"/>
		</xsl:variable>

		<xsl:variable name="rubricTitle">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="pText">
					<xsl:apply-templates select="rubric" mode="getRubricTitle"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="outputMetadata">
			<xsl:with-param name="id" select="@id"/>
			<xsl:with-param name="pointsAvailable" select="$activityPointsAvailable"/>
			<xsl:with-param name="teacherPointsAvailable" select="$teacherPointsAvailable"/>

			<xsl:with-param name="activityMode" select="$activityMode"/>
			<xsl:with-param name="gradableType" select="$activityGradableType"/>
			<xsl:with-param name="type" select="'activity'"/>
			<xsl:with-param name="title" select="$rubricTitle"/>
			<xsl:with-param name="itemSets" select="$itemSets"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template match="/activity/itemBased" mode="buildItemSetsMetadata">
	{
		<xsl:apply-templates mode="buildItemSetsMetadata"/>
	}
	</xsl:template>

	<xsl:template match="/activity/itemBased/itemSet" mode="buildItemSetsMetadata">
		"<xsl:value-of select="@type"/>": [
			<xsl:apply-templates mode="buildItemSetsMetadata"/>
		]
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="/activity/itemBased/itemSet/item" mode="buildItemSetsMetadata">
		"<xsl:value-of select="@id"/>"
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="referenceContent">
		<xsl:variable name="referenceContentTitle">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="pText">
					<xsl:apply-templates select="metadata" mode="getReferenceContentTitle"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="outputMetadata">
			<xsl:with-param name="id" select="@id"/>
			<xsl:with-param name="type" select="'referenceContent'"/>
			<xsl:with-param name="title" select="$referenceContentTitle"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template name="outputMetadata">
		<xsl:param name="id" select="''"/>
		<xsl:param name="pointsAvailable" select="'0'"/>
		<xsl:param name="teacherPointsAvailable" select="'0'"/>

		<xsl:param name="activityMode" select="''"/>
		<xsl:param name="gradableType" select="'non-gradable'"/>
		<xsl:param name="type" select="'activity'"/>
		<xsl:param name="title" select="''"/>
		<xsl:param name="itemSets" select="''"/>

		{
			"id": "<xsl:value-of select="$id"/>",
			"pointsAvailable": "<xsl:value-of select="$pointsAvailable" />",
			"teacherPointsAvailable": "<xsl:value-of select="$teacherPointsAvailable"/>",
			"availablePoints": "<xsl:value-of select="$pointsAvailable + $teacherPointsAvailable"/>",
			"activityMode": "<xsl:value-of select="$activityMode"/>",
			"gradable": "<xsl:value-of select="$gradableType"/>",
			"type": "<xsl:value-of select="$type"/>",
			<xsl:if test="$itemSets != ''">
				"itemSets": <xsl:value-of select="$itemSets"/>,
			</xsl:if>
			"title": "<xsl:value-of select="normalize-space($title)"/>"
		}

	</xsl:template>

	<xsl:template match="rubric" mode="getRubricTitle">
		<xsl:apply-templates mode="getRubricTitle"/>
	</xsl:template>

	<xsl:template match="referenceContent/metadata/title" mode="getReferenceContentTitle">
		<xsl:apply-templates mode="getReferenceContentTitle"/>
	</xsl:template>

	<xsl:template match="text()" mode="getRubricTitle">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="text()" mode="getReferenceContentTitle">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>
