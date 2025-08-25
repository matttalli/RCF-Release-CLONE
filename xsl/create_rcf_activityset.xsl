<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="create_rcf_activity.xsl"/>

	<xsl:param name="outputFooter" select="'YES'"/>
	<xsl:param name="series" select="'all_elements_v2'"/>
	<xsl:param name="sharedAssetsURL" select="'../series/all_elements_v2/shared'"/>
	<xsl:param name="rcfPath" select="'../rcf'"/>

	<xsl:template match="activitySet">
		<div class="activitySetContainer">
			<xsl:apply-templates/>
		</div>
		<script type="text/javascript" src="{$sharedAssetsURL}/js/app.js"></script>
	</xsl:template>

	<xsl:template match="activitySetMetaData">
		<div class="headerBar">
			<span class="scoreBar "></span>
			<span class="singleButton resetAllAnswersButton clearfix">Reset All</span>
			<span class="pageTitle"><xsl:value-of select="metadata/title"/><xsl:if test="metadata/subtitle"> (<xsl:value-of select="metadata/subtitle"/>)</xsl:if></span>
		</div>
	</xsl:template>
	
	<xsl:template match="metadata"/>
	
	<xsl:template name="activityFooterControls" match="activityFooter" priority="0">
		<xsl:param name="activityNode"/>
		<xsl:param name="pointsAvailable"/>

		<xsl:variable name="activityID"><xsl:value-of select="$activityNode/@id"/></xsl:variable>

		<xsl:if test="$pointsAvailable &gt; 0">
			<div class="actScoring">
				<span class="actScore" id="activity_{$activityID}_score">0 / <xsl:value-of select="$pointsAvailable"/></span>
				<span class="actScoreButton">
					<a href="javascript:;"
						class="checkAnswersButton singleButton"><span>Check</span></a>
					<a href="javascript:;"
						class="showAnswersButton singleButton"><span>Show Answers</span></a>
					<a href="javascript:;"
						class="resetAnswersButton singleButton"><span>Try Again</span></a>
				</span>
			</div>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
