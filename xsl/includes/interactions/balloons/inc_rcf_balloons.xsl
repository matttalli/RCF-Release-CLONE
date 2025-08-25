<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="balloonsGame">
		<xsl:variable name="balloonsId">balloons_<xsl:value-of select="ancestor::activity/@id"/></xsl:variable>

		<xsl:variable name="alternativeSpriteUrl">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="alternativeSprite/@sharedAsset"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'games'"/>
				<xsl:with-param name="useAssetsUrl" select="$sharedAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="balloonsContainer" data-rcfinteraction="balloons" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			id="{$balloonsId}"
		>

			<div class="mockTextForPhaserFontLoading"/>

			<!-- output the staging screens -->
			<!-- if there is no coverScreen element, output the default screen -->
			<xsl:choose>
				<xsl:when test="not(coverScreen)">
					<xsl:call-template name="balloonsStartScreen"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- output the coverScreen element -->
					<xsl:apply-templates select="coverScreen"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:call-template name="balloonsResumeScreen"/>
			<xsl:call-template name="balloonsGameWonScreen"/>
			<xsl:call-template name="balloonsGameOverScreen"/>

			<!-- output the balloons game stage - contains game information (lives / remaining items text, and will contain the canvas element at runtime) -->
			<div class="rcfBalloons" id="balloons_gameStage_{ancestor::activity/@id}">

				<!-- new container for lives / remaining items text -->
				<div class="gameInfo">
					<ul class="lives">
						<li class="life"></li>
						<li class="life"></li>
						<li class="life"></li>
					</ul>
					<ul class="remainingItems">
						<!-- populated at runtime -->
					</ul>
				</div>

				<!-- json object container which gets parsed / removed at runtime -->
				<div class="jsonObject">
					{
						"items":
						{
							<xsl:for-each select="items/item">
							"<xsl:value-of select="@id"/>":
							{
								"imageName": "<xsl:if test="@image"><xsl:value-of select="@image"/></xsl:if>",
								"imageLocation": "<xsl:if test="@image"><xsl:call-template name="imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template></xsl:if>",
								"text": "<xsl:apply-templates/>",
								"found": false
							}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
						},
						"distractors":
						{
							<xsl:for-each select="distractors/item">
							"<xsl:value-of select="@id"/>":
							{
								"imageName": "<xsl:if test="@image"><xsl:value-of select="@image"/></xsl:if>",
								"imageLocation": "<xsl:if test="@image"><xsl:call-template name="imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template></xsl:if>",
								"text": "<xsl:apply-templates/>",
								"found": false
							}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
						},
						"questions":
						[
							<xsl:for-each select="questions/question">
							{
								"id": "<xsl:value-of select="@id"/>",
								"audio": "<xsl:value-of select="prompt/audio/track/@src"/>",
								"items":
								[
									<xsl:for-each select="item">
										"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if>
									</xsl:for-each>
								]
							}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
						],
						"settings":
						{
							"correct": "<xsl:value-of select="questions/@correct"/>",
							"missedBalloonPenalty": "<xsl:value-of select="@missedBalloonPenalty"/>",
							"play": "<xsl:choose><xsl:when test="questions/@play"><xsl:value-of select="questions/@play"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>",
							"baseSpeed": "<xsl:choose><xsl:when test="questions/@baseSpeed"><xsl:value-of select="questions/@baseSpeed"/></xsl:when><xsl:otherwise>3</xsl:otherwise></xsl:choose>"
						},
						"alternativeSprite": "<xsl:choose><xsl:when test="alternativeSprite/@sharedAsset"><xsl:value-of select="$alternativeSpriteUrl"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>"
					}
				</div>

			</div>

			<div class="dev-prompts">
				<xsl:apply-templates select="questions/question"/>
			</div>

		</div>
	</xsl:template>

	<xsl:template name="imageUrl">
		<xsl:param name="image"/>
		<xsl:choose>
			<xsl:when test="$environment='capePreview'"><xsl:value-of select="$host"/><xsl:value-of select="$image"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="$image"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="balloonsStartScreen">
		<div class="stagingScreen startScreen">
			<button class="startGameButton" data-rcfTranslate="" type="button">[ components.button.startGame ]</button>
		</div>
	</xsl:template>

	<xsl:template name="balloonsGameWonScreen">
		<div class="stagingScreen gameWonScreen">
			<button class="replayGameButton" data-rcfTranslate=""  type="button">[ components.button.replayGame ]</button>
		</div>
	</xsl:template>

	<xsl:template name="balloonsGameOverScreen">
		<div class="stagingScreen gameOverScreen">
			<button class="replayGameButton" data-rcfTranslate="" ype="button">[ components.button.tryAgain ]</button>
		</div>
	</xsl:template>

	<xsl:template name="balloonsResumeScreen">
		<div class="stagingScreen resumeScreen">
			<button class="resumeGameButton" data-rcfTranslate="" aria-label="[ components.button.resumeGame ]" type="button">[ components.button.resumeGame ]</button>
		</div>
	</xsl:template>

	<!-- rcf_balloons -->
	<xsl:template match="balloonsGame" mode="getRcfClassName">
		rcfBalloonsGame
	</xsl:template>

</xsl:stylesheet>
