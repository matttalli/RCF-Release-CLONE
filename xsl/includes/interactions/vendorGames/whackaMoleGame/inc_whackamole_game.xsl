<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- calls the underlying templates in ../inc_vendor_games.xsl -->

	<xsl:template match="whackaMoleGame">
		<div class="fiab-gameContainer whackaMoleGame start"
			data-rcfinteraction="whackaMoleGame" data-rcfid="{@id}"
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
	<xsl:template match="whackaMoleGame" mode="fiab-getGamePlayMode">whackamole</xsl:template>

	<!-- get the 'gameSkin' for each game type -->
	<xsl:template match="whackaMoleGame" mode="fiab-getGameSkin">
		<xsl:choose>
			<xsl:when test="@skin"><xsl:value-of select="@skin"/></xsl:when>
			<xsl:otherwise>bubbles</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get the 'penaliseWrongAnswers' value for each gane type -->
	<xsl:template match="whackaMoleGame" mode="fiab-getPenaliseWrongAnswers">n</xsl:template>

	<!-- rcf_whackamole -->
	<xsl:template match="whackaMoleGame" mode="getRcfClassName">
		rcfWhackaMoleGame
	</xsl:template>

</xsl:stylesheet>
