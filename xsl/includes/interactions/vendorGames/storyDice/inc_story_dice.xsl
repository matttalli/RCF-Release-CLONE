<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="storyDice">
		<div class="fiab-gameContainer storyDice game start"
			data-rcfInteraction="storyDice" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createStoryCubesGame"
		>
			<!-- output staging screen -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>
			<!-- output game stage / json data -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>
		</div>
	</xsl:template>

	<xsl:template match="storyDice" mode="fiab-outputGameStage">
		<!-- asset path is injected into the game json by the js -->
		<div class="fiab-gameStage">
			<div class="jsonObject">
				{
					"diceSet": [
						<xsl:apply-templates select="diceSet" mode="fiab-storyDiceJson"/>
					]
				}
			</div>
		</div>
	</xsl:template>

	<xsl:template match="diceSet" mode="fiab-storyDiceJson">
			{
				"dice": [
					<xsl:apply-templates select="die" mode="fiab-storyDiceJson"/>
				]
			}<xsl:if test="following-sibling::diceSet">,</xsl:if>
	</xsl:template>

	<xsl:template match="die" mode="fiab-storyDiceJson">
		{
			"faces": [
				<xsl:apply-templates mode="fiab-storyDiceJson"/>
			]
		}<xsl:if test="following-sibling::die">,</xsl:if>
	</xsl:template>

	<xsl:template match="faceBuiltIn" mode="fiab-storyDiceJson">
		{
			"option": "<xsl:value-of select="@option"/>"
			<xsl:if test="@label">, "label": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="@label"/></xsl:call-template>"</xsl:if>
		}<xsl:if test="following-sibling::faceBuiltIn or following-sibling::faceCustom">,</xsl:if>

	</xsl:template>

	<xsl:template match="faceCustom" mode="fiab-storyDiceJson">
		{
			"src": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@src"/></xsl:call-template>"
			<xsl:if test="@label">, "label": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="@label"/></xsl:call-template>"</xsl:if>
		}<xsl:if test="following-sibling::faceBuiltIn or following-sibling::faceCustom">,</xsl:if>
	</xsl:template>

	<xsl:template match="storyDice" mode="getRcfClassName">
		rcfStoryDice
	</xsl:template>

</xsl:stylesheet>
