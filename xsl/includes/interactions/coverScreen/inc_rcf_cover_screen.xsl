<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--
	Currently only used by <findInImage> - expect to be added to other interactions / games soon
-->
	<xsl:template match="coverScreen">
		<!-- determine any override classes based in the interaction containing this <coverScreen> element -->
		<xsl:variable name="coverScreenClasses">
			<xsl:choose>
				<xsl:when test="ancestor::findInImage">findInImageStartScreen findInImageGameStartScreen</xsl:when>
				<xsl:when test="ancestor::sequenceTileMaze">startScreen sequenceTileMazeStartScreen sequenceTileMazeGameStartScreen</xsl:when>
				<xsl:when test="ancestor::categoriseTileMaze">startScreen categoriseTileMazeStartScreen categoriseTileMazeGameStartScreen</xsl:when>
				<xsl:when test="ancestor::spellingBee">startScreen spellingBeeStartScreen spellingBeeGameStartScreen</xsl:when>
				<xsl:when test="ancestor::balloonsGame">startScreen balloonsGameStartScreen</xsl:when>
				<xsl:when test="ancestor::bubblesGame">startScreen bubblesGameStartScreen</xsl:when>
				<xsl:when test="ancestor::barrelsGame">startScreen barrelsGameStartScreen</xsl:when>
				<xsl:when test="ancestor::whackaMoleGame">startScreen whackaMoleGameStartScreen</xsl:when>
				<xsl:when test="ancestor::snapGame">startScreen snapGameStartScreen</xsl:when>
				<xsl:when test="ancestor::laneChangerGame">startScreen laneChangerGameStartScreen</xsl:when>
				<xsl:when test="ancestor::quizGame">startScreen quizGameStartScreen</xsl:when>
				<xsl:when test="ancestor::cogsGame">startScreen cogsGameStartScreen</xsl:when>
				<xsl:when test="ancestor::storyDice">startScreen storyDiceStartScreen</xsl:when>
				<xsl:when test="ancestor::spinnerGame">startScreen spinnerGameStartScreen</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- output the cover screen contents -->
		<div class="{normalize-space(concat('stagingScreen', ' ', @class, ' ', $coverScreenClasses))}">
			<xsl:apply-templates/>
			<div class="startGameContainer">
				<button class="playGameButton startGameButton" type="button">
					<span data-rcfTranslate="">[ components.button.startGame ]</span>
					<span class="visually-hidden" data-rcfTranslate=""> [ interactions.fiabGames.gameNotCompatibleWithSR ]</span>
				</button>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="coverScreen/gameInstruction">
		<div class="gameInstruction">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>
