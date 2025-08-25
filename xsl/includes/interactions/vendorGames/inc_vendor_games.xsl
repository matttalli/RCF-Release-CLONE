<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- include the stylesheets for the 'bubbles' based games -->
	<xsl:include href="./bubblesGame/inc_bubbles_game.xsl"/>
	<xsl:include href="./barrelsGame/inc_barrels_game.xsl"/>
	<xsl:include href="./whackaMoleGame/inc_whackamole_game.xsl"/>
	<xsl:include href="./snapGame/inc_snap_game.xsl"/>
	<xsl:include href="./quizGame/inc_quiz_game.xsl"/>
	<xsl:include href="./laneChangerGame/inc_lane_changer_game.xsl"/>
	<xsl:include href="./cogsGame/inc_cogs_game.xsl"/>

	<xsl:include href="./storyDice/inc_story_dice.xsl"/>
	<xsl:include href="./spinnerGame/inc_spinner_game.xsl"/>
	<xsl:include href="./spellingBee/inc_spelling_bee.xsl"/>


	<!-- output staging screens for all fiab based games -->
	<xsl:template match="bubblesGame | barrelsGame | whackaMoleGame | snapGame | quizGame | laneChangerGame | cogsGame | storyDice | spinnerGame | spellingBee" mode="fiab-outputStagingScreens">
		<!-- output the staging screens -->
		<xsl:choose>
			<!-- if there is no coverScreen element, output the default screen -->
			<xsl:when test="not(coverScreen)">
				<xsl:call-template name="fiab-startScreen"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- output the coverScreen element -->
				<xsl:apply-templates select="coverScreen"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="fiab-pauseScreen"/>
	</xsl:template>

	<!-- output the game stage for the bubble based game (snap, cogsGame and dice are handled in their own xsl file) -->
	<xsl:template match="bubblesGame | barrelsGame | whackaMoleGame | laneChangerGame" mode="fiab-outputGameStage">
		<!-- output the game stage - this is where the fiab runtime will render the game -->
		<div class="fiab-gameStage">
			<!-- output the game questions json - is removed at runtime -->
			<xsl:call-template name="fiab-outputGameQuestionsJson">
				<xsl:with-param name="gameElement" select="."/>
				<xsl:with-param name="gamePlayMode"><xsl:apply-templates select="." mode="fiab-getGamePlayMode"/></xsl:with-param>
				<xsl:with-param name="gameSkin"><xsl:apply-templates select="." mode="fiab-getGameSkin"/></xsl:with-param>
				<xsl:with-param name="penaliseWrongAnswers"><xsl:apply-templates select="." mode="fiab-getPenaliseWrongAnswers"/></xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>

	<!-- cover screens - not currently used - requires more coordinated work with fiab -->
	<xsl:template name="fiab-startScreen">
		<div class="stagingScreen startScreen">
			<button class="playGameButton startGameButton" type="button">
				<span data-rcfTranslate="">[ components.button.startGame ]</span>
				<span class="visually-hidden" data-rcfTranslate=""> [ interactions.fiabGames.gameNotCompatibleWithSR ]</span>
			</button>
		</div>
	</xsl:template>

	<xsl:template name="fiab-pauseScreen">
		<div class="stagingScreen resumeScreen">
			<button class="playGameButton resumeGameButton" type="button">
				<span data-rcfTranslate="">[ components.button.resumeGame ]</span>
				<span class="visually-hidden" data-rcfTranslate=""> [ interactions.fiabGames.gameNotCompatibleWithSR ]</span>
			</button>
		</div>
	</xsl:template>


	<!-- outputting the game json to the html - will be removed at runtime - for all games except SNAP which has a different structure -->
	<xsl:template name="fiab-outputGameQuestionsJson">
		<!-- takes the 'game element' (eg bubblesGame, whackaMoleGame or barrelsGame element) as a parameter -->
		<xsl:param name="gameElement"/>
		<!-- takes a 'play mode' which configures the fish in a bottle game for bubbles, barrels or whackamole -->
		<xsl:param name="gamePlayMode" select="'bubbles'"/>
		<!-- takes a 'skin' - bubbles or river -->
		<xsl:param name="gameSkin" select="'bubbles'"/>
		<!-- determine whether missed items count as a penalty - default is 'y', whackamole would be a bit hard with 'y' ... but maybe this should be configurable ? -->
		<xsl:param name="penaliseWrongAnswers" select="'y'"/>

		<!-- initialise the 'play' and 'baseSpeed' parameters if not supplied in the xml -->
		<xsl:variable name="play">
			<xsl:choose>
				<xsl:when test="$gameElement/questions/@play"><xsl:value-of select="$gameElement/questions/@play"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count($gameElement/questions/question)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="baseSpeed">
			<xsl:choose>
				<xsl:when test="$gameElement/@baseSpeed"><xsl:value-of select="$gameElement/@baseSpeed"/></xsl:when>
				<xsl:otherwise>3</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="assetPathForEnvironment">
			<xsl:choose>
				<!-- we want and '' empty asset path value for Cape Preview -->
				<xsl:when test="$environment='capePreview'"></xsl:when>
				<xsl:otherwise><xsl:value-of select="$levelAssetsURL"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- outputs json object into the html which is removed at runtime -->
		<div class="jsonObject">
			{
				<!-- we no longer provide assetPath here as the javascript runtime can provide a full url when running - not easy to determine at html generation time! -->
				"items": {
					<xsl:for-each select="$gameElement/items/item">
						<xsl:apply-templates select="." mode="fiab-outputJsonQuestionItem"/>
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
				},
				<!-- setup all the distractors for the game -->
				"distractors": {
					<xsl:for-each select="distractors/item">
						<xsl:apply-templates select="." mode="fiab-outputJsonQuestionItem"/>
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
				},
				<!-- setup the questions for the game -->
				"questions": [
					<xsl:for-each select="questions/question">{
						<xsl:variable name="promptText"><xsl:apply-templates select=".//text()"/></xsl:variable>

						"id": "<xsl:value-of select="@id"/>",
						<!-- check if there is audio for the question -->
						<xsl:choose>
							<xsl:when test="prompt/imageAudio">
								"audio": "<xsl:call-template name="fiab-audioUrl"><xsl:with-param name="audio" select="prompt/imageAudio/@audio"/></xsl:call-template>",
							</xsl:when>
							<xsl:when test="prompt/audio">
								"audio": "<xsl:call-template name="fiab-audioUrl"><xsl:with-param name="audio" select="prompt/audio/track/@src"/></xsl:call-template>",
							</xsl:when>
						</xsl:choose>

						<!-- escape any quotes in the text -->
						"text": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$promptText"/></xsl:call-template>",

						<!-- output y/n for image -->
						<xsl:choose>
							<xsl:when test="prompt/imageAudio">
								"image": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="prompt/imageAudio/@src"/></xsl:call-template>",
							</xsl:when>
							<xsl:when test="prompt/image">
								"image": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="prompt/image/@src"/></xsl:call-template>",
							</xsl:when>
						</xsl:choose>

						<!-- output the array of item/@id values for the correct question answers -->
						"items": [
							<xsl:for-each select="item">
								"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if>
							</xsl:for-each>
						]
					}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
				],
				<!-- the settings for the fiab runtime -->
				"settings": {
					<xsl:choose>
						<xsl:when test="name(.)='bubblesGame'"/>
						<xsl:when test="name(.)='barrelsGame'"/>
						<xsl:when test="name(.)='whackaMoleGame'"/>
						<xsl:otherwise>
							"correct": "<xsl:value-of select="questions/@correct"/>",
						</xsl:otherwise>
					</xsl:choose>
					"skin": "<xsl:value-of select="$gameSkin"/>",
					"gameplayVariant": "<xsl:value-of select="$gamePlayMode"/>",
					"missedItemPenalty": "<xsl:value-of select="$penaliseWrongAnswers"/>",
					"wrongItemPenalty": "<xsl:value-of select="$penaliseWrongAnswers"/>",
					"play": "<xsl:value-of select="$play"/>",
					"baseSpeed": "<xsl:value-of select="$baseSpeed"/>"
				}
			}
		</div>
	</xsl:template>

	<xsl:template match="item" mode="fiab-outputJsonQuestionItem">
		<xsl:variable name="itemText">
			<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())"/></xsl:call-template>
		</xsl:variable>

		"<xsl:value-of select="@id"/>": {
			"image": "<xsl:if test="@image"><xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template></xsl:if>",
			"text": "<xsl:value-of select="$itemText"/>"
		}
	</xsl:template>

	<xsl:template name="fiab-imageUrl">
		<!-- outputs the image location for cape or for standard processing -->
		<xsl:param name="image"/>
		<xsl:variable name="imageUrl">
			<xsl:choose>
				<xsl:when test="$environment='capePreview'"><xsl:value-of select="$host"/><xsl:value-of select="$image"/></xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="starts-with($image, '/')">images<xsl:value-of select="$image"/></xsl:when>
						<xsl:otherwise>images/<xsl:value-of select="$image"/></xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="normalize-space($imageUrl)"/>
	</xsl:template>

	<xsl:template name="fiab-audioUrl">
		<!-- outputs the image location for cape or for standard processing -->
		<xsl:param name="audio"/>
		<xsl:variable name="audioUrl">
			<xsl:choose>
				<xsl:when test="$environment='capePreview'"><xsl:value-of select="$host"/><xsl:value-of select="$audio"/></xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="starts-with($audio, '/')">audio<xsl:value-of select="$audio"/></xsl:when>
						<xsl:otherwise>audio/<xsl:value-of select="$audio"/></xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="normalize-space($audioUrl)"/>

	</xsl:template>

	<xsl:template match="text()" mode="outputStagingScreens"/>

</xsl:stylesheet>
