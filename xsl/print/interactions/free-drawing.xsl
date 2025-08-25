<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="freeDrawing[@isInteraction='y']">
		<div class="{@printClass}" data-rcfid="{@id}">

			<!-- Drawing 'canvas' that may or may not contain an image -->
			<div class="rcfPrint-interactionContainer">
				<xsl:choose>
					<xsl:when test="./backgroundImage and ./backgroundImage/@src">
						<xsl:variable name="imageSrc">
							<xsl:call-template name="getAssetSource">
								<xsl:with-param name="assetSource" select="backgroundImage/@src"/>
								<xsl:with-param name="useEnvironment" select="$environment"/>
								<xsl:with-param name="assetPartialPathName" select="'images'"/>
								<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
							</xsl:call-template>
						</xsl:variable>
						<img class="rcfPrint-image" src="{$imageSrc}"></img>
					</xsl:when>
					<xsl:otherwise>
						<div class="rcfPrint-canvasContainer">
							<div class="rcfPrint-pseudoImage"></div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<!-- supplementary text answer if enabled -->
			<xsl:if test="./@includePrintedTextArea='y'">
				<div class="rcfPrint-supplementaryStudentsTextAnswer">
					<div class="rcfPrint-wol"></div>
					<div class="rcfPrint-wol"></div>
				</div>
			</xsl:if>

		</div>
	</xsl:template>

	<xsl:template match="freeDrawing[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
		<div class="{@printClass} rcfPrint-answer" data-rcfid="{@id}">

			<!-- answer model if included -->
			<xsl:apply-templates select="answerModel" mode="outputOpenGradableAnswerModel"/>

			<!-- marking guidance -->
			<xsl:call-template name="outputOpenGradableMarkingGuidance">
				<xsl:with-param name="markingGuidanceElement" select="markingGuidance"/>
				<xsl:with-param name="maxScore" select="@max_score"/>
			</xsl:call-template>

		</div>
	</xsl:template>

</xsl:stylesheet>
