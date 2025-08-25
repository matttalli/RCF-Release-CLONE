<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="overallScore">
		<!-- get number of points (closed gradable) for the activity -->
		<xsl:variable name="activityPoints"><xsl:call-template name="activityPoints"><xsl:with-param name="activityNode" select="ancestor::activity"/></xsl:call-template></xsl:variable>

		<xsl:variable name="activityPointsAvailable">
			<xsl:choose>
				<xsl:when test="$activityPoints!=''"><xsl:value-of select="$activityPoints"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- get number of open-gradable points for the activity -->
		<xsl:variable name="teacherPointsAvailable">
			<xsl:call-template name="teacherPointsAvailable"><xsl:with-param name="activityNode" select="ancestor::activity"/></xsl:call-template>
		</xsl:variable>

		<!-- get the gradable type -->
		<xsl:variable name="activityGradableType">
			<xsl:call-template name="getActivityGradableType">
				<xsl:with-param name="activityNode" select="ancestor::activity"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- only output overall score html if open-gradable... for now ... -->
		<xsl:if test="$activityGradableType='open-gradable'">
			<xsl:call-template name="outputOverallScoreContent">
				<xsl:with-param name="totalPointsAvailable" select="($activityPointsAvailable + $teacherPointsAvailable)"/>
				<xsl:with-param name="showPercentage" select="@showPercentage"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="outputOverallScoreContent">
		<xsl:param name="totalPointsAvailable" select="'0'"/>
		<xsl:param name="showPercentage" select="'n'"/>

		<div data-rcfinteraction="rcfOverallScore" class="scoreContainer overallScore">
			<p>
				<span class="scoreLabel" data-rcfTranslate="">[ components.label.totalScore ]</span> <span class="score"><span class="scoreResult"></span> <span data-rcfTranslate="">[ components.label.outOf ]</span> <span class="maxScoreLabel"><xsl:value-of select="$totalPointsAvailable"/></span><xsl:if test="$showPercentage='y'"> <span class="scorePercentage"></span></xsl:if></span>
				<span class="noMarks" data-rcfTranslate="" >[ components.label.noMarks ]</span>
			</p>
		</div>

	</xsl:template>
	<xsl:template match="overallScore" mode="getUnmarkedInteractionName">
		rcfOverallScore
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
