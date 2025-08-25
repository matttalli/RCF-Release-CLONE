<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		output the movingtargets container and json

		<div ....

			<div class='rcfCrossword'>
				<table ....

				</table>
			</div>

			<div class='clueContainer'>
				... populated by the javascript ...
			</div>

		</div>
	-->

	<xsl:template match="movingTargets">
		<xsl:variable name="speed">
			<xsl:choose>
				<xsl:when test="@speed"><xsl:value-of select="@speed"/></xsl:when>
				<xsl:otherwise>100</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="movingTargetsContainer" data-rcfinteraction="movingTargets" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			id="movingTarget_{ancestor::activity/@id}_{@id}">

			<div class="rcfMovingTargets" id="gameStage_{ancestor::activity/@id}_{@id}">
				<!-- output JSON structure for the words -read in (then removed) by the rcf_crossword.js classes -->
				<div class="jsonObject">
					{
						"targets":[
					<xsl:for-each select="targets/target">
					{
						"id": "<xsl:value-of select="@id"/>",
						"audio": "<xsl:value-of select="$levelAssetsURL"/>/audio/<xsl:value-of select="@audio"/>",
						"image": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="@image"/>"
					}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
						],
						"speed": "<xsl:value-of select="$speed"/>",
						"assets": {
						<xsl:if test="assets/scenery/sceneBackground/@image">
							<xsl:variable name="sceneBackgroundMoving">
								<xsl:choose>
									<xsl:when test="assets/scenery/sceneBackground/@moving='y'"><xsl:value-of select="assets/scenery/sceneBackground/@moving"/></xsl:when>
									<xsl:otherwise>n</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							"sceneBackground": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="assets/scenery/sceneBackground/@image"/>",
							"sceneBackgroundMoving": "<xsl:value-of select="$sceneBackgroundMoving"/>",
						</xsl:if>
						<xsl:if test="assets/scenery/targetBackground/@image">
							<xsl:variable name="targetBackgroundMoving">
								<xsl:choose>
									<xsl:when test="assets/scenery/targetBackground/@moving='y'">y</xsl:when>
									<xsl:otherwise>n</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							"targetBackground": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="assets/scenery/targetBackground/@image"/>",
							"targetBackgroundMoving": "<xsl:value-of select="$targetBackgroundMoving"/>",
						</xsl:if>
						<xsl:if test="assets/scenery/foreground/@image">
							<xsl:variable name="foregroundMoving">
								<xsl:choose>
									<xsl:when test="assets/scenery/foreground/@moving='y'">y</xsl:when>
									<xsl:otherwise>n</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							"foreground": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="assets/scenery/foreground/@image"/>",
							"foregroundMoving": "<xsl:value-of select="$foregroundMoving"/>",
							<xsl:if test="assets/scenery/foreground/@bounce='y'">"foregroundBounce": "y",</xsl:if>
						</xsl:if>
							"crosshairs": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="assets/scenery/crosshairs/@image"/>",
							"collisionTarget": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="assets/scenery/transparentTarget/@image"/>",
							"clueButton": "<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="assets/scenery/clueButton/@image"/>"
						},
						"audio": {
							"success": "<xsl:value-of select="$levelAssetsURL"/>/audio/<xsl:value-of select="assets/audio/success/@src"/>",
							"fail": "<xsl:value-of select="$levelAssetsURL"/>/audio/<xsl:value-of select="assets/audio/fail/@src"/>",
							"gameover": "<xsl:value-of select="$levelAssetsURL"/>/audio/<xsl:value-of select="assets/audio/gameover/@src"/>"
						}
					}
				</div>
				<xsl:call-template name="movingTargetsStartScreen"/>
				<xsl:call-template name="movingTargetsGameOverScreen"/>
			</div>
		</div>
	</xsl:template>

	<!-- rcf_moving_targets -->
	<xsl:template match="movingTargets" mode="getRcfClassName">
		rcfMovingTargets
	</xsl:template>

	<xsl:template name="movingTargetsStartScreen">
		<div class="stagingScreen startScreen">
			<button class="startGameButton" data-rcfTranslate="" type="button">[ components.button.startGame ]</button>
		</div>
	</xsl:template>

	<xsl:template name="movingTargetsGameOverScreen">
		<div class="stagingScreen gameOver">
			<h1>Congratulations</h1>
			<button class="startGameButton" data-rcfTranslate="" type="button">[ components.button.replayGame ]</button>
		</div>
	</xsl:template>

</xsl:stylesheet>
