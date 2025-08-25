<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- return a unique list of all the marked interactions in the activity -->
	<xsl:template name="getInteractionsInElement">
		<xsl:param name="rootNode" select="//activity[1]"/>
		<xsl:variable name="interactions">
			<xsl:apply-templates select="$rootNode" mode="getRcfClassName"/>
		</xsl:variable>
		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($interactions)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getOpenGradableInteractionsInElement">
		<xsl:param name="rootNode" select="//activity[1]"/>
		<xsl:variable name="interactions">
			<xsl:apply-templates select="$rootNode" mode="getOpenGradableInteractionName"/>
		</xsl:variable>
		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($interactions)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getUnmarkedInteractionsInElement">
		<xsl:param name="rootNode" select="//activity[1]"/>
		<xsl:variable name="interactions">
			<xsl:apply-templates select="$rootNode" mode="getUnmarkedInteractionName"/>
		</xsl:variable>
		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($interactions)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getItemBasedInteractionsInElement">
		<xsl:param name="itemListNode" select="/activity/itemListContainer/itemList"/>
		<xsl:variable name="interactions"><xsl:apply-templates select="$itemListNode" mode="getItemBasedRcfClassName"/></xsl:variable>
		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($interactions)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getDesktopOnlyInteractionsInElement">
		<xsl:param name="rootNode" select="//activity[1]"/>
		<xsl:variable name="desktopOnlyInteractions"><xsl:apply-templates select="$rootNode" mode="getRcfDesktopClassName"/></xsl:variable>
		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($desktopOnlyInteractions)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getMobileOnlyInteractionsInElement">
		<xsl:param name="rootNode" select="//activity[1]"/>
		<xsl:variable name="mobileOnlyInteractions"><xsl:apply-templates select="$rootNode" mode="getRcfMobileClassName"/></xsl:variable>
		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($mobileOnlyInteractions)"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="text()" mode="getRcfClassName"/>
	<xsl:template match="text()" mode="getRcfDesktopClassName"/>
	<xsl:template match="text()" mode="getRcfMobileClassName"/>
	<xsl:template match="text()" mode="getItemBasedRcfClassName"/>
	<xsl:template match="text()" mode="getOpenGradableInteractionName"/>
	<xsl:template match="text()" mode="getUnmarkedInteractionName"/>

</xsl:stylesheet>
