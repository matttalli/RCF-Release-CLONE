<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- (not) hangman stylesheet -->
<!-- example xml :

	numAttempts should be '8' if missing (Unless otherwise agreed upon)

			<hangman id="hangman_1" numAttempts="8"  class="mm_sheep">
				<words>
					<word id="word_1">
						<value>MARS</value>
					</word>
				</words>
			</hangman>
-->
	<xsl:template match="hangman">
		<xsl:variable name="numAttempts">
			<xsl:choose>
				<xsl:when test="not(@numAttempts)">8</xsl:when>
				<xsl:otherwise><xsl:value-of select="@numAttempts"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="wordList">
			<xsl:for-each select="words/word"><xsl:value-of select="value"/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each>
		</xsl:variable>

		<xsl:variable name="showClue">
			<xsl:choose>
				<xsl:when test="not(@showClue='n')">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="hangmanClass"><xsl:value-of select="@class"/> <xsl:if test="$showClue='y'"> showClue</xsl:if></xsl:variable>

		<!-- output the hangman div -->
		<div class="{normalize-space(concat('hangmanContainer ', $hangmanClass))}" id="hangman_{@id}"
			data-rcfinteraction="hangman"
			data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-numattempts="{$numAttempts}"
			data-wordlist="{$wordList}"
			data-showclue="{$showClue}">

			<div class="hangmanGame">
				<div class="triesRemaining">
					<span class="label">
						<xsl:choose>
							<xsl:when test="not(@triesLabel) or @triesLabel=''"><xsl:attribute name="data-rcfTranslate"></xsl:attribute>[ interactions.hangman.triesRemaining ]</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@triesLabel"/>
							</xsl:otherwise>
						</xsl:choose>
					</span> : <span class="tries"><xsl:value-of select="$numAttempts"/></span>
				</div>

				<xsl:call-template name="outputStage">
					<xsl:with-param name="stageNumber" select="'1'"/>
					<xsl:with-param name="numAttempts" select="$numAttempts"/>
				</xsl:call-template>
				<div class="stage gameOverStage">
<!-- TBD....
<span class="tryAgainButton singleButton">Try again</span>
<span class="anotherWordButton singleButton">Another word ?</span>
-->
				</div>
			</div>
			<div class="hangmanInteractionContainer">
				<!-- output all clues, 'active' class shows only the required clue, all the rest are hidden -->
				<div class="wordClues">
					<xsl:for-each select="words/word">
						<div class="wordClue" data-wordid="word_{position()-1}" id="clue_{position()-1}">
							<xsl:apply-templates select="clue"/>
						</div>
					</xsl:for-each>
				</div>
				<div class="wordContainer"></div>
				<div class="letterChooser"></div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="outputStage">
		<xsl:param name="stageNumber"/>
		<xsl:param name="numAttempts"/>
		<xsl:variable name="stageClass">stage<xsl:value-of select="$stageNumber"/></xsl:variable>

		<div class="stage {$stageClass}">
			<div/>
		</div>
		<xsl:if test="$stageNumber &lt; $numAttempts">
			<xsl:call-template name="outputStage">
				<xsl:with-param name="stageNumber" select="$stageNumber+1"/>
				<xsl:with-param name="numAttempts" select="$numAttempts"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="hangman" mode="getUnmarkedInteractionName">
		rcfHangman
	</xsl:template>

</xsl:stylesheet>
