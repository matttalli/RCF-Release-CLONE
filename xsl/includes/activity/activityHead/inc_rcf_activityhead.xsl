<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		output ActivityHead/Title/Subtitle/Description
	-->

	<!-- ignore default <xsl:apply-templates/> call of activity head -->
	<xsl:template match="activityHead"/>

	<xsl:template match="activityHead" mode="outputActivityHeader">
		<div class="activityHead">
			<xsl:apply-templates mode="outputActivityHeader"/>
		</div>
	</xsl:template>

	<xsl:template match="activityTitle" mode="outputActivityHeader">
		<h2 class="activityTitle"><xsl:apply-templates/></h2>
	</xsl:template>

	<xsl:template match="activitySubtitle" mode="outputActivityHeader">
		<h3 class="activitySubTitle"><xsl:apply-templates/></h3>
	</xsl:template>

	<xsl:template match="activityDescription" mode="outputActivityHeader">
		<p class="activityDescription"><xsl:apply-templates/></p>
	</xsl:template>

</xsl:stylesheet>