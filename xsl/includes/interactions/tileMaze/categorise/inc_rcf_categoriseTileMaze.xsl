<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="categoriseTileMaze">
		<xsl:variable name="questionsJson">
			<xsl:apply-templates select="." mode="outputQuestionsJson" />
		</xsl:variable>
		<xsl:apply-templates select="." mode="categoriseTileMaze-errorScreen" />
		<div data-rcfinteraction="categoriseTileMaze" class="tileMazeContainer" data-rcfid="{@id}" data-questionsJson="{normalize-space($questionsJson)}">
			<div class="mockTextForPhaserFontLoading"></div>
			<!-- output the cover screen if there is one, or just the default one -->
			<xsl:choose>
				<xsl:when test="not(coverScreen)">
					<xsl:apply-templates select="." mode="categoriseTileMaze-startScreen" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="coverScreen"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="." mode="categoriseTileMaze-nextQuestionScreen" />
			<xsl:apply-templates select="." mode="categoriseTileMaze-gameWonScreen" />
			<xsl:apply-templates select="." mode="categoriseTileMaze-gameOverScreen" />
			<xsl:apply-templates select="questions"/>
			<xsl:apply-templates select="." mode="categoriseTileMaze-gameContainer" />
			<xsl:apply-templates select="." mode="categoriseTileMaze-itemCollection" />
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-errorScreen">
		<div class="invalidTileMaze hidden">
			<h3></h3>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-startScreen">
		<div class="stagingScreen startScreen">
			<button class="startGameButton" type="button" tabindex="0" aria-label="[ components.button.startGame ]" data-rcfTranslate="">[ components.button.startGame ]</button>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-nextQuestionScreen">
		<div class="stagingScreen nextQuestionScreen">
			<p class="feedbackText" data-rcfTranslate="">[ components.label.correct ]</p>
			<p class="collectionCountText">
				<span data-rcfTranslate="">[ components.label.youGot ] </span>
				<span class="collectionCounterValue"></span>
			</p>
			<div class="itemsCollected"><ul></ul></div>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-gameWonScreen">
		<div class="stagingScreen gameWonScreen">
			<p class="feedbackText" data-rcfTranslate="">[ components.label.wellDone ]</p>
			<button class="replayGameButton" type="button" tabindex="0" aria-label="[ components.button.replayGame ]" data-rcfTranslate="">[ components.button.replayGame ]</button>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-gameOverScreen">
		<div class="stagingScreen gameOverScreen">
			<p class="feedbackText" data-rcfTranslate="">[ components.label.gameOver ]</p>
			<button class="replayGameButton" type="button" tabindex="0" aria-label="[ components.button.tryAgain ]" data-rcfTranslate="">[ components.button.tryAgain ]</button>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-gameContainer">
		<div class="tileMazeStageContainer">
			<ul class="lives">
				<li class="life"></li>
				<li class="life"></li>
				<li class="life"></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze/questions">
		<div class="dev-prompts tileMazePrompts">
			<!-- output in inc_rcf_prompt.xsl -->
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="categoriseTileMaze-itemCollection">
		<div class="tileMazeCollection">
			<ul>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze" mode="outputQuestionsJson">
		{
			"id": "<xsl:value-of select="@id" />",
			"show": "<xsl:choose><xsl:when test="@show"><xsl:value-of select="@show"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>",
			<xsl:apply-templates mode="outputQuestionsJson" />
		}
	</xsl:template>

	<xsl:template match="categoriseTileMaze/coverScreen" mode="outputQuestionsJson"/>

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

	<xsl:template match="categoriseTileMaze/questions" mode="outputQuestionsJson">
		"questions": [
		<xsl:for-each select="question">{
			"id": "<xsl:value-of select="@id" />",
			"length": "<xsl:value-of select="categoryItems/@length" />",
			"items": [
				<xsl:for-each select="categoryItems/item">{
					"id": "<xsl:value-of select="@id" />",
					"value": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())" /></xsl:call-template>",
					"audio": "<xsl:if test="@audio"><xsl:call-template name="getAudioSource"><xsl:with-param name="sourceValue" select="@audio"/></xsl:call-template></xsl:if>",
					"image": "<xsl:if test="@image"><xsl:call-template name="getImageSource"><xsl:with-param name="sourceValue" select="@image"/></xsl:call-template></xsl:if>"
				}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			],
			"distractors": [
				<xsl:for-each select="distractors/item">{
					"id": "<xsl:value-of select="@id" />",
					"value": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())" /></xsl:call-template>",
					"audio": "<xsl:if test="@audio"><xsl:call-template name="getAudioSource"><xsl:with-param name="sourceValue" select="@audio"/></xsl:call-template></xsl:if>",
					"image": "<xsl:if test="@image"><xsl:call-template name="getImageSource"><xsl:with-param name="sourceValue" select="@image"/></xsl:call-template></xsl:if>"
				}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
		<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>
		]
	</xsl:template>

	<xsl:template match="categoriseTileMaze//item/text()"/>

	<xsl:template match="categoriseTileMaze" mode="getRcfClassName">
		rcfCategoriseTileMaze
	</xsl:template>


</xsl:stylesheet>
