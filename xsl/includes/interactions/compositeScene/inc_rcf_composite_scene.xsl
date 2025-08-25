<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	inc_rcf_composite_scene.xsl

	generate the html for a composite scene interaction in an rcf activity

-->

<!-- from xml :

        <compositeScene id="scene_1" class="mm_farmyard" playClueButtonLabel="Play the clue" backgroundImage="farm.jpg">
            <audioAssets>
                <gamestart src="whatever.mp3"/>
                <incorrect src="incorrect_choice.mp3"/>
                <gameover src="gameover.mp3"/>
            </audioAssets>

            <items>
        		<item id="item_1" class="mm_cow" audio="where_is_the_cow.mp3" correctAudio="moo.mp3" rank="1"/>
        		<item id="item_2" class="mm_sheep" audio="where_is_the_sheep.mp3" correctAudio="baa.mp3"  rank="2"/>
        		<item id="item_3" class="mm_llama" audio="where_is_the_llama.mp3" correctAudio="quack.mp3"  rank="3"/>
        	</items>

        </compositeScene>

-->

	<xsl:template match="compositeScene">

		<div class="compositeSceneContainer" data-rcfinteraction="compositeScene" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-audio-gamestart="{audioAssets/gamestart/@src}"
			data-audio-gameover="{audioAssets/gameover/@src}"
			data-audio-incorrect="{audioAssets/incorrect/@src}"
		>
			<div class="compositeScene {@class}">
				<img class="compositeSceneBackground" src="{$levelAssetsURL}/images/{@backgroundImage}"/>
				<div class="sceneItems">
					<xsl:for-each select="items/item">
						<div class="sceneItem {@class}" data-sceneid="{@id}"
							data-audio-clue="{@audioClue}"
							data-audio-correct="{@correctAudio}">
							<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
							<img src="{$levelAssetsURL}/images/{@image}"/>
						</div>
					</xsl:for-each>
				</div>
				<span class="playClueButton singleButton">
					<xsl:choose>
						<xsl:when test="@playClueButtonLabel='' or not(@playClueButtonLabel)"><xsl:attribute name="data-rcfTranslate"></xsl:attribute>[ interactions.compositeScene.playClue ]</xsl:when>
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

	<!-- rcf_composite_scene -->
	<xsl:template match="compositeScene" mode="getRcfClassName">
		rcfCompositeScene
	</xsl:template>

</xsl:stylesheet>
