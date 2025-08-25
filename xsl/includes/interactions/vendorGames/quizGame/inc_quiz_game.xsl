<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- calls the underlying templates in ../inc_vendor_games.xsl -->

	<xsl:template match="quizGame">
		<div class="fiab-gameContainer quizGame game start"
			data-rcfinteraction="quizGame" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createQuizGame"
		>
			<!-- output the staging screens -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens" />

			<!-- output the game stage -->
			<div class="fiab-gameStage">
				<div class="jsonObject">
					{
						"assetPath": "<xsl:value-of select="$levelAssetsURL"/>",
						"questions": [
							<xsl:for-each select="questions/question">
							{
								<xsl:variable name="questionPrompt"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(prompt/text())"/></xsl:call-template></xsl:variable>
								<xsl:variable name="answerText"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(answer/text())"/></xsl:call-template></xsl:variable>
								"id": "<xsl:value-of select="@id"/>",
								"text": "<xsl:value-of select="$questionPrompt"/>",
								"items": ["<xsl:value-of select="$answerText"/>"],
								"distractors": [
								<xsl:for-each select="distractors/item">
									<xsl:variable name="distractorText"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())"/></xsl:call-template></xsl:variable>
									"<xsl:value-of select="$distractorText"/>"
									<xsl:if test="position() != last()">,</xsl:if>
								</xsl:for-each>
								]
							}<xsl:if test="position()!=last()">,</xsl:if>
							</xsl:for-each>
						],
						"settings": {
							"one_player_questions_per_round": <xsl:call-template name="fiab-getQuestionsPerRound">
									<xsl:with-param name="questionsPerRound"><xsl:value-of select="settings/onePlayer/@questionsPerRound"/></xsl:with-param>
									<xsl:with-param name="defaultValue">4</xsl:with-param>
								</xsl:call-template>,
							"two_player_questions_per_round": <xsl:call-template name="fiab-getQuestionsPerRound">
								<xsl:with-param name="questionsPerRound"><xsl:value-of select="settings/twoPlayer/@questionsPerRound"/></xsl:with-param>
								<xsl:with-param name="defaultValue">2</xsl:with-param>
							</xsl:call-template>,
							"three_player_questions_per_round": <xsl:call-template name="fiab-getQuestionsPerRound">
								<xsl:with-param name="questionsPerRound"><xsl:value-of select="settings/threePlayer/@questionsPerRound"/></xsl:with-param>
							</xsl:call-template>,
							"four_player_questions_per_round": <xsl:call-template name="fiab-getQuestionsPerRound">
								<xsl:with-param name="questionsPerRound"><xsl:value-of select="settings/fourPlayer/@questionsPerRound"/></xsl:with-param>
							</xsl:call-template>
						}
					}
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="fiab-getQuestionsPerRound">
		<xsl:param name="questionsPerRound"/>
		<xsl:param name="defaultValue">1</xsl:param>
		<xsl:choose>
			<xsl:when test="$questionsPerRound != ''"><xsl:value-of select="$questionsPerRound"/></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$defaultValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="quizGame//text()" mode="fiab-outputStagingScreens" />

	<xsl:template match="quizGame" mode="getRcfClassName">
		rcfQuizGame
	</xsl:template>

</xsl:stylesheet>
