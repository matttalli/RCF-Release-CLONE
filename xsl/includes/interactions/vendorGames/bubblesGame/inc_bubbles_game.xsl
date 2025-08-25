<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- calls the underlying templates in ../inc_vendor_games.xsl -->

	<xsl:template match="bubblesGame">
		<div class="fiab-gameContainer bubblesGame start"
			data-rcfinteraction="bubblesGame" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createBubblesGame"
		>
			<!-- output the staging screens -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>

			<!-- output the fiab game stage - contains game information (questions json which is removed on game initialisation) -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>
		</div>
	</xsl:template>

	<!-- get the playmode for each game type -->
	<xsl:template match="bubblesGame" mode="fiab-getGamePlayMode">original</xsl:template>

	<!-- get the 'gameSkin' for each game type -->
	<xsl:template match="bubblesGame" mode="fiab-getGameSkin">
		<xsl:choose>
			<xsl:when test="@skin"><xsl:value-of select="@skin"/></xsl:when>
			<xsl:otherwise>bubbles</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get the 'penaliseWrongAnswers' value for each gane type -->
	<xsl:template match="bubblesGame" mode="fiab-getPenaliseWrongAnswers">y</xsl:template>

	<!-- rcf_bubblesGame -->
	<xsl:template match="bubblesGame" mode="getRcfClassName">
		rcfBubblesGame
	</xsl:template>

</xsl:stylesheet>
