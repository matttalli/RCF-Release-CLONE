<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- calls the underlying templates in ../inc_vendor_games.xsl -->


	<xsl:template match="cogsGame">
		<div class="fiab-gameContainer cogsGame start"
			data-rcfInteraction="cogsGame" data-rcfId="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createCogsGame"
		>
			<!-- output the staging screens -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>

			<!-- output the fiab game stage - contains game information (questions json which is removed on game initialisation) -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>
		</div>
	</xsl:template>

	<!-- override the default (bubbles) processing for items/item as the json is slightly different -->
	<xsl:template match="cogsGame//item" mode="fiab-outputJsonQuestionItem">
		<xsl:variable name="itemText">
			<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())"/></xsl:call-template>
		</xsl:variable>

		"<xsl:value-of select="@id"/>": {
			"image": "<xsl:if test="@image"><xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="@image"/></xsl:call-template></xsl:if>",
			"text": "<xsl:value-of select="$itemText"/>"
		}
	</xsl:template>


	<xsl:template match="cogsGame" mode="fiab-outputGameStage">
		<div class="fiab-gameStage">
			<xsl:apply-templates select="." mode="fiab-outputGameQuestionsJson"/>
		</div>
	</xsl:template>

	<xsl:template match="cogsGame" mode="fiab-outputGameQuestionsJson">
		<xsl:variable name="gameSkin">
			<xsl:choose>
				<xsl:when test="not(@skin)">snake</xsl:when>
				<xsl:otherwise><xsl:value-of select="@skin"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="play">
			<xsl:choose>
				<xsl:when test="questions/@play"><xsl:value-of select="questions/@play"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(questions/question)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="jsonObject">
			{
				"assetPath": "<xsl:value-of select="$levelAssetsURL"/>",
				"settings": {
					"skin": "<xsl:value-of select="$gameSkin"/>",
					"play": "<xsl:value-of select="$play"/>"
				},
				"questions": [
					<xsl:for-each select="questions/question">
					{
						<xsl:variable name="promptText"><xsl:apply-templates select="./prompt//text()"/></xsl:variable>

						"id": "<xsl:value-of select="@id"/>",

						<!-- escape any quotes in the text -->
						"text": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$promptText"/></xsl:call-template>",

						<!-- check if there is audio for the question -->
						<xsl:choose>
							<xsl:when test="prompt/imageAudio">
								"audio": "<xsl:call-template name="fiab-audioUrl"><xsl:with-param name="audio" select="prompt/imageAudio/@audio"/></xsl:call-template>",
							</xsl:when>
							<xsl:when test="prompt/audio">
								"audio": "<xsl:call-template name="fiab-audioUrl"><xsl:with-param name="audio" select="prompt/audio/track/@src"/></xsl:call-template>",
							</xsl:when>
						</xsl:choose>

						<!-- output y/n for image -->
						<xsl:choose>
							<xsl:when test="prompt/imageAudio">
								"image": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="prompt/imageAudio/@src"/></xsl:call-template>",
							</xsl:when>
							<xsl:when test="prompt/image">
								"image": "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="prompt/image/@src"/></xsl:call-template>",
							</xsl:when>
						</xsl:choose>

						<!-- output the sentence composed of the fixed text and the cogtext elements -->
						<xsl:apply-templates select="sentence" mode="fiab-outputCogSentence"/>

					}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
				]
			}
		</div>
	</xsl:template>

	<xsl:template match="sentence" mode="fiab-outputCogSentence">
		"sentence": [
			<xsl:apply-templates mode="fiab-outputCogSentence"/>
		]
	</xsl:template>

	<xsl:template match="fixedText" mode="fiab-outputCogSentence">
		<xsl:variable name="fixedText"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())"/></xsl:call-template></xsl:variable>
		[
			{
				"fixedText": "<xsl:value-of select="$fixedText"/>"
			}
		]<xsl:if test="count(following-sibling::cogText) > 0 or count(following-sibling::fixedText)">,</xsl:if>
	</xsl:template>

	<xsl:template match="cogText" mode="fiab-outputCogSentence">
		[
			<xsl:apply-templates mode="fiab-outputCogSentence"/>
		]<xsl:if test="count(following-sibling::cogText) > 0 or count(following-sibling::fixedText)">,</xsl:if>
	</xsl:template>

	<xsl:template match="cogText/item" mode="fiab-outputCogSentence">
		<xsl:variable name="itemText"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(text())"/></xsl:call-template></xsl:variable>
		{
			"cogText": "<xsl:value-of select="$itemText"/>",
			"correct": <xsl:value-of select="@correct='y'"/>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<!-- rcf_cogsGame -->
	<xsl:template match="cogsGame" mode="getRcfClassName">
		rcfCogsGame
	</xsl:template>

</xsl:stylesheet>
