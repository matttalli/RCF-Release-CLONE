<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="sequenceTileMaze">
		<xsl:variable name="questionsJson">
			<xsl:apply-templates select="." mode="outputQuestionsJson" />
		</xsl:variable>
		<xsl:apply-templates select="." mode="sequenceTileMaze-errorScreen" />
		<div data-rcfinteraction="sequenceTileMaze" class="tileMazeContainer" data-rcfid="{@id}" data-questionsJson="{normalize-space($questionsJson)}">
			<div class="mockTextForPhaserFontLoading"></div>
			<!-- output the cover screen if there is one, or just the default one -->
			<xsl:choose>
				<xsl:when test="not(coverScreen)">
					<xsl:apply-templates select="." mode="sequenceTileMaze-startScreen" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="coverScreen"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="." mode="sequenceTileMaze-nextQuestionScreen" />
			<xsl:apply-templates select="." mode="sequenceTileMaze-gameWonScreen" />
			<xsl:apply-templates select="." mode="sequenceTileMaze-gameOverScreen" />
			<xsl:apply-templates select="questions"/>
			<xsl:apply-templates select="." mode="sequenceTileMaze-gameContainer" />
			<xsl:apply-templates select="." mode="sequenceTileMaze-itemCollection" />
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-errorScreen">
		<div class="invalidTileMaze hidden">
			<h3></h3>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-startScreen">
		<div class="stagingScreen startScreen">
			<button class="startGameButton" data-mode="resetQuestions" type="button" tabindex="0" aria-label="[ components.button.startGame ]" data-rcfTranslate="">[ components.button.startGame ]</button>
		</div>
	</xsl:template>


	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-nextQuestionScreen">
		<div class="stagingScreen nextQuestionScreen">
			<p class="feedbackText" data-rcfTranslate="">[ components.label.correct ]</p>
			<p class="nextQuestionText"></p>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-gameWonScreen">
		<div class="stagingScreen gameWonScreen">
			<p class="feedbackText" data-rcfTranslate="">[ components.label.wellDone ]</p>
			<button class="replayGameButton" data-mode="resetQuestions" type="button" tabindex="0" aria-label="[ components.button.replayGame ]" data-rcfTranslate="">[ components.button.replayGame ]</button>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-gameOverScreen">
		<div class="stagingScreen gameOverScreen">
			<p class="feedbackText" data-rcfTranslate="">[ components.label.gameOver ]</p>
			<button class="replayGameButton" data-mode="replayQuestion" type="button" tabindex="0" aria-label="[ components.button.tryAgain ]" data-rcfTranslate="">[ components.button.tryAgain ]</button>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-gameContainer">
		<div class="tileMazeStageContainer">
			<ul class="lives">
				<li class="life"></li>
				<li class="life"></li>
				<li class="life"></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze/questions">
		<div class="dev-prompts tileMazePrompts">
			<!-- output in inc_rcf_prompt.xsl -->
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="sequenceTileMaze-itemCollection">
		<div class="tileMazeCollection">
			<ul>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze" mode="outputQuestionsJson">
		{
		"id": "<xsl:value-of select="@id" />",
		"show": "<xsl:choose><xsl:when test="@show"><xsl:value-of select="@show"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>",
		<xsl:apply-templates mode="outputQuestionsJson" />
		}
	</xsl:template>

	<xsl:template match="sequenceTileMaze/coverScreen" mode="outputQuestionsJson"/>

	<xsl:template match="alternativeSprite" mode="outputQuestionsJson">
		<xsl:variable name="spriteUrl">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="@sharedAsset"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'games'"/>
				<xsl:with-param name="useAssetsUrl" select="$sharedAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>
		"alternativeSprite": "<xsl:value-of select="$spriteUrl"/>",
	</xsl:template>

	<xsl:template match="sequenceTileMaze/questions" mode="outputQuestionsJson">
		"questions": [
		<xsl:for-each select="question">{
			"id": "<xsl:value-of select="@id" />",
			"steps": [
			<xsl:for-each select="path/step">{
				"id": "<xsl:value-of select="@id" />",
				"optional": "<xsl:choose><xsl:when test="@optional"><xsl:value-of select="@optional"/></xsl:when><xsl:otherwise>n</xsl:otherwise></xsl:choose>",
				"correctItems": [
				<xsl:for-each select="item[@correct='y']">
						{
							"id": "<xsl:value-of select="@id" />",
							"value": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())" /></xsl:call-template>",

							"correct": true
						}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
				],
				"incorrectItems": [
				<xsl:for-each select="item[not(@correct='y')]">
					{
						"id": "<xsl:value-of select="@id" />",
						"value": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())" /></xsl:call-template>",
						"correct": false
					}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
				]
			}
			<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
			]
			,
			"distractors": [
				<xsl:for-each select="distractors/item">{
					"id": "<xsl:value-of select="@id" />",
					"value": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())" /></xsl:call-template>",
					"stepIndex": -1,
					"correct": false
				}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
			}
			<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>
		]
	</xsl:template>

	<xsl:template match="sequenceTileMaze//item/text()"/>

	<xsl:template match="sequenceTileMaze" mode="getRcfClassName">
		rcfSequenceTileMaze
	</xsl:template>


</xsl:stylesheet>
