<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="spinnerGame">
		<div class="fiab-gameContainer spinnerGame game start"
			data-rcfInteraction="spinnerGame" data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			data-initialiseFunction="createSpinnerGame"
		>

			<!-- output staging screen -->
			<xsl:apply-templates select="." mode="fiab-outputStagingScreens"/>
			<!-- output game stage / json data -->
			<xsl:apply-templates select="." mode="fiab-outputGameStage"/>
		</div>
	</xsl:template>

	<xsl:template match="spinnerGame" mode="fiab-outputGameStage">
		<xsl:variable name="removeAfterSelection">
			<xsl:choose>
				<xsl:when test="@removeAfterSelection='n'">n</xsl:when>
				<xsl:otherwise>y</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- asset path is injected into the game json by the js -->
		<div class="fiab-gameStage">
			<div class="jsonObject">
				{
					"settings": {
						"removeAfterSelection": "<xsl:value-of select="$removeAfterSelection"/>"
					}
				}
			</div>
		</div>

	</xsl:template>

	<xsl:template match="spinnerGame" mode="getRcfClassName">
		rcfSpinnerGame
	</xsl:template>

</xsl:stylesheet>
