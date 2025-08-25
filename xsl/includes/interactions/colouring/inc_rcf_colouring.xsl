<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	inc_rcf_colouring.xsl

	generate the html for a colouring interaction in an rcf activity

-->

<!-- from xml :

<colouring id="colouring_1" class="mm_whatever" playClueButtonLabel="whatever">
	<audioAssets>
        <gamestart src="listen_and_colour.mp3"/>
        <correct src="correct.mp3"/>
        <incorrect src="guess_incorrect.mp3"/>
        <gameover src="smb_gameover.wav"/>
	</audioAssets>

	<colours>
		<colour id="colour_1" class="mm_blue" image="paint_blue.png"/>
		<colour id="colour_2" class="mm_green" image="paint_green.png"/>
		<colour id="colour_3" class="mm_red" image="paint_red.png"/>
			.
			. etc
	</colours>

	<items>
		<item id="item_1" correctColour="colour_3" class="mm_apple" image="apple.png" correctImage="red_apple.png" audioClue="colour_the_apple_red.mp3"/>

		<item id="item_2" correctColour="colour_5" class="mm_banana" image="banana.png" correctImage="yellow_banana.png" audioClue="colour_the_banana_yellow.mp3"/>

		<item id="item_3" correctColour="colour_4" class="mm_plums" image="plums.png" correctImage="purple_plums.png" audioClue="colour_the_plums_purple.mp3"/>
			.
			. etc
	</items>
</colouring>
-->

	<xsl:template match="colouring">

		<div class="colouringContainer" data-rcfinteraction="colouring" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-audio-gamestart="{audioAssets/gamestart/@src}"
			data-audio-gameover="{audioAssets/gameover/@src}"
			data-audio-correct="{audioAssets/correct/@src}"
			data-audio-incorrect="{audioAssets/incorrect/@src}"
		>
			<div class="colouring {@class}">
				<xsl:if test="@backgroundImage">
					<img class="colouringBackground" src="{$levelAssetsURL}/images/{@backgroundImage}"/>
				</xsl:if>
				<div class="coloursContainer">
					<xsl:for-each select="colours/colour">
						<div data-rcf-colour-id="{@id}" class="colourPaletteItem {@class}" data-rcf-class="{@class}">
							<xsl:if test="@image">
								<img src="{$levelAssetsURL}/images/{@image}" />
							</xsl:if>
						</div>
					</xsl:for-each>
				</div>
 				<div class="colourItemsContainer">
					<xsl:for-each select="items/item">
						<div class="colourItem {@class}"
							data-rcf-colour-id="{@correctColour}"
							data-correctimage="{$levelAssetsURL}/images/{@correctImage}"
							data-audio-clue="{@audioClue}">
							<xsl:if test="@rank">
								<xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute>
							</xsl:if>
							<img src="{$levelAssetsURL}/images/{@image}"/>
						</div>
					</xsl:for-each>
 				</div>
			</div>
			<div class="clueTools">
				<span class="playClueButton singleButton">
					<xsl:choose>
						<xsl:when test="not(@playClueButtonLabel) or @playClueButtonLabel=''"><xsl:attribute name="data-rcfTranslate"></xsl:attribute>[ interactions.colouring.playClue ]</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@playClueButtonLabel"/>
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</div>
			<div class="gameOver">
				<h1 data-rcfTranslate="">[ components.label.wellDone ]</h1>
			</div>
			<div class="startGame">
				<span class="singleButton startGameButton" data-rcfTranslate="">[ components.button.startGame ]</span>
			</div>
		</div>
	</xsl:template>

	<!-- rcf_colouring -->
	<xsl:template match="colouring" mode="getRcfClassName">
		rcfColouring
	</xsl:template>

</xsl:stylesheet>
