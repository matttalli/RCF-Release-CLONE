<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- calls the underlying templates in ../inc_vendor_games.xsl -->

	<xsl:template match="snapGame">
		<div class="fiab-gameContainer snapGame start"
			data-rcfinteraction="snapGame" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createSnapGame"
		>
			<!-- output the staging screens -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>

			<!-- output the fiab game stage - contains game information (questions json which is removed on game initialisation) -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>
		</div>
	</xsl:template>

	<xsl:template match="snapGame" mode="fiab-outputGameStage">
		<div class="fiab-gameStage">
			<xsl:apply-templates select="." mode="fiab-outputGameQuestionsJson"/>
		</div>
	</xsl:template>

	<!-- override the default fiab-outputGameQuestionsJson template to output the snap game specific json -->
	<xsl:template match="snapGame" mode="fiab-outputGameQuestionsJson">
		<xsl:variable name="gamePlayMode" select="'snap'"/>
		<xsl:variable name="gameSkin" select="'space'"/>
		<xsl:variable name="penaliseWrongAnswers" select="'y'"/>

		<!-- initialise the 'play' and 'baseSpeed' parameters if not supplied in the xml -->
		<xsl:variable name="play">
			<xsl:choose>
				<xsl:when test="cards/@play"><xsl:value-of select="cards/@play"/></xsl:when>
				<xsl:otherwise>5</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="baseSpeed">
			<xsl:choose>
				<xsl:when test="@baseSpeed"><xsl:value-of select="@baseSpeed"/></xsl:when>
				<xsl:otherwise>3</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- outputs json object into the html which is removed at runtime -->
		<div class="jsonObject">
			{
				<!-- assetPath tells the fiab runtime where to load game assets from -->
				"assetPath": "<xsl:value-of select="$levelAssetsURL"/>",
				<!-- setup all the 'items' which make up the choosable answers in the game -->
				"items": [
					<xsl:for-each select="cards/pair/item">
					{
						"id": "<xsl:value-of select="@id"/>",
						<xsl:choose>
							<xsl:when test="@image">
								"image": "y",
								"imageName": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template>",
							</xsl:when>
							<xsl:otherwise>
								"image": "n",
								"text": "<xsl:apply-templates select="text()"/>",
							</xsl:otherwise>
						</xsl:choose>
						"targetId": "<xsl:value-of select="../target/@id"/>"
					}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>

					<xsl:if test="count(distractors/items/item) &gt; 0">
						<xsl:for-each select="distractors/items/item">
						, {
							"id": "<xsl:value-of select="@id"/>",
							<xsl:choose>
								<xsl:when test="@image">
									"image": "y",
									"imageName": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template>",
								</xsl:when>
								<xsl:otherwise>
									"image": "n",
									"text": "<xsl:apply-templates select="text()"/>",
								</xsl:otherwise>
							</xsl:choose>
							"distractor": "y"
						}
						</xsl:for-each>
					</xsl:if>
				],
				"targets": [
					<xsl:for-each select="cards/pair/target">
					{
						"id": "<xsl:value-of select="@id"/>",
						<xsl:choose>
							<xsl:when test="@image">
								"image": "y",
								"imageName": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template>"
							</xsl:when>
							<xsl:otherwise>
								"image": "n",
								"text": "<xsl:apply-templates select="text()"/>"
							</xsl:otherwise>
						</xsl:choose>
					}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>

					<xsl:if test="count(distractors/targets/target) &gt; 0">
						<xsl:for-each select="distractors/targets/target">
						, {
							"id": "<xsl:value-of select="@id"/>",
							<xsl:choose>
								<xsl:when test="@image">
									"image": "y",
									"imageName": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template>",
								</xsl:when>
								<xsl:otherwise>
									"image": "n",
									"text": "<xsl:apply-templates select="text()"/>",
								</xsl:otherwise>
							</xsl:choose>
							"distractor": "y"
						}
						</xsl:for-each>
					</xsl:if>
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

	<!-- get the playmode for each game type -->
	<xsl:template match="snapGame" mode="fiab-getGamePlayMode">snap</xsl:template>

	<!-- get the 'gameSkin' for each game type -->
	<xsl:template match="snapGame" mode="fiab-getGameSkin">
		<xsl:choose>
			<xsl:when test="@skin"><xsl:value-of select="@skin"/></xsl:when>
			<xsl:otherwise>space</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get the 'penaliseWrongAnswers' value for each gane type -->
	<xsl:template match="snapGame" mode="fiab-getPenaliseWrongAnswers">y</xsl:template>

	<!-- rcf_snapGame -->
	<xsl:template match="snapGame" mode="getRcfClassName">
		rcfSnapGame
	</xsl:template>

</xsl:stylesheet>
