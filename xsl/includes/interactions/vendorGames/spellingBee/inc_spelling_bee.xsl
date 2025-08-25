<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="spellingBee">

		<div class="fiab-gameContainer spellingBee start"
			data-rcfinteraction="spellingBee" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createSpellingBeeGame"
			tabindex="0"
		>
			<!-- output the staging screens -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>

			<!-- output the fiab game stage - contains game information (questions json which is removed on game initialisation) -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>

		</div>
	</xsl:template>

	<xsl:template match="spellingBee" mode="fiab-outputGameStage">
		<!-- asset path is injected into the game json by the js -->
		<xsl:variable name="numberOfQuestionsToPlay">
			<xsl:choose>
				<xsl:when test="not(@play) and @play!=''">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="@play"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="gameTimeLimit">
			<xsl:choose>
				<xsl:when test="not(@timeLimit) and @timeLimit != ''">60</xsl:when>
				<xsl:otherwise><xsl:value-of select="@timeLimit"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="@keyboard and not(@keyboard='')"><xsl:value-of select="@keyboard"/></xsl:when>
				<xsl:otherwise>en</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="fiab-gameStage">
			<div class="jsonObject">
				{
					"settings": {
						"timeLimit": "<xsl:value-of select="$gameTimeLimit"/>",
						"progressiveChallenge": true,
						"language": "<xsl:value-of select="$language"/>",
						"play": "<xsl:value-of select="$numberOfQuestionsToPlay"/>"
					},

					"questionSets": [
						<xsl:apply-templates select="wordSets/wordSet" mode="fiab-spellingBee-outputGameStage"/>
					]
				}
			</div>
		</div>
	</xsl:template>

	<xsl:template match="wordSet" mode="fiab-spellingBee-outputGameStage">
		{
			"id": "<xsl:value-of select="@id"/>",
			<xsl:if test="@play and @play &gt; 0">
				"play": <xsl:value-of select="@play"/>,
			</xsl:if>

			"questions": [
				<xsl:apply-templates select="word" mode="fiab-spellingBee-outputGameStage"/>
			]
		}<xsl:if test="following-sibling::wordSet">,</xsl:if>
	</xsl:template>

	<xsl:template match="word" mode="fiab-spellingBee-outputGameStage">
		<xsl:variable name="clueText">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="pText"><xsl:apply-templates select="clue//text()" mode="fiab-spellingBee-outputGameStage"/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		{
			"id": "<xsl:value-of select="@id"/>",
			"acceptable": [
				<xsl:for-each select="acceptable/item">
					"<xsl:value-of select="text()"/>"
					<xsl:if test="position() != last()">,</xsl:if>
				</xsl:for-each>
			],
			<!--
				FIAB currently (25/10/2024) will crash if we don't supply a clue, so we always supply one even if it's just empty, eg clue: {}

				ideally they'd have a structure like:

				clue: {
					audio: "path/to/audio",
					image: "path/to/image",
					text: "... clue text ..."
				}

				rather than

				clue: {
					audio: "path/to/audio",
					image: "path/to/image"
				},
				textDescription: "..."
			-->
			"clue": {
				<xsl:if test="clue/@audio">
					"audio": "<xsl:call-template name="fiab-audioUrl"><xsl:with-param name="audio" select="clue/@audio"/></xsl:call-template>"
					<xsl:if test="clue/@image or $clueText!=''">,</xsl:if>
				</xsl:if>

				<xsl:if test="clue/@image">
					"image":  "<xsl:call-template name="fiab-imageUrl"><xsl:with-param name="image" select="clue/@image"/></xsl:call-template>"
					<xsl:if test="$clueText!=''">,</xsl:if>
				</xsl:if>
				<xsl:if test="string-length($clueText)!=0">
					"text": "<xsl:value-of select="normalize-space($clueText)"/>"
				</xsl:if>
			},


			"textDescription": "<xsl:value-of select="normalize-space($clueText)"/>"

		}<xsl:if test="following-sibling::word">,</xsl:if>
	</xsl:template>

	<xsl:template match="clue//text()" mode="fiab-spellingBee-outputGameStage"><xsl:copy /></xsl:template>

	<xsl:template match="spellingBee" mode="getRcfClassName">
		rcfSpellingBee
	</xsl:template>

</xsl:stylesheet>
