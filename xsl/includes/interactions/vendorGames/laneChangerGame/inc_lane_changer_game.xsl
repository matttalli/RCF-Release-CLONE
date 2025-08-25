<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- calls the underlying templates in ../inc_vendor_games.xsl -->

	<xsl:template match="laneChangerGame">
		<div class="fiab-gameContainer laneChangerGame start"
			data-rcfinteraction="laneChangerGame" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createLaneChangerGame"
		>
			<!-- output the staging screens -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>

			<!-- output the fiab game stage - contains game information (questions json which is removed on game initialisation) -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>
		</div>
	</xsl:template>

	<!-- get the playmode for each game type -->
	<xsl:template match="laneChangerGame" mode="fiab-getGamePlayMode"></xsl:template>

	<!-- get the 'gameSkin' for each game type -->
	<xsl:template match="laneChangerGame" mode="fiab-getGameSkin">bubbles</xsl:template>

	<!-- get the 'penaliseWrongAnswers' value for each gane type -->
	<xsl:template match="laneChangerGame" mode="fiab-getPenaliseWrongAnswers">y</xsl:template>

	<!-- override the default (bubbles) processing for items/item as the json is slightly different -->
	<xsl:template match="laneChangerGame//item" mode="fiab-outputJsonQuestionItem">
		<xsl:variable name="itemText">
			<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())"/></xsl:call-template>
		</xsl:variable>

		"<xsl:value-of select="@id"/>": {
			"image": "<xsl:if test="@image"><xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template></xsl:if>",
			"text": "<xsl:value-of select="$itemText"/>"
		}
	</xsl:template>

	<!-- rcf_laneChangerGame -->
	<xsl:template match="laneChangerGame" mode="getRcfClassName">
		rcfLaneChangerGame
	</xsl:template>

</xsl:stylesheet>
