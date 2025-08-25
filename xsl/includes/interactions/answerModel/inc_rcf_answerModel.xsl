<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	Answer Model can now be inside <writing> and <freeDrawing>
-->

	<!-- standard answer model output -->
	<xsl:template match="answerModel">
		<!--
			answer model is a 'answerKey' interaction - this way, all the answerkey interaction javascript
			handles the clicks for showing / hiding the element
		-->
		<xsl:variable name="hasImageClass"><xsl:if test="@image">hasImage</xsl:if></xsl:variable>

		<div data-rcfinteraction="answerKey" data-rcfid="{../@id}_answerModel" class="{normalize-space(concat('answerKeyContainer ', $hasImageClass))}">
			<div class="answerKeyBlock answerKey selectable" >
				<xsl:if test="@image">
					<xsl:variable name="imageUrl">
						<xsl:call-template name="getImageSource">
							<xsl:with-param name="sourceValue" select="@image"/>
						</xsl:call-template>
					</xsl:variable>
					<div>
						<img src="{$imageUrl}" alt="Answer Model" class="answerModelImage"/>
					</div>
				</xsl:if>
				<div>
					<p><xsl:apply-templates/></p>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- answer mode for leave teacher feedback mode -->
	<xsl:template match="answerModel" mode="outputOpenGradableAnswerModel">
		<xsl:variable name="id"><xsl:value-of select="../@id"/>_answerModel_leaveFeedback</xsl:variable>
		<xsl:variable name="hasImageClass"><xsl:if test="@image">hasImage</xsl:if></xsl:variable>

		<div data-rcfinteraction="collapsibleBlock"
			data-ignoreNextAnswer="y"
			class="{normalize-space(concat('block collapsibleContainer modelAnswer ', $hasImageClass))}"
			data-rcfid="{$id}"
			data-initialopen="n"
		>
			<span class="singleButton collapsibleButton">
				<span class="whenOpened innerButtonCaption" data-rcfTranslate="">[ interactions.openGradable.answerModelOpened ]</span>
				<span class="whenClosed innerButtonCaption" data-rcfTranslate="">[ interactions.openGradable.answerModelClosed ]</span>
			</span>

			<br/>
			<br/>

			<div class="block">
				<xsl:if test="@image">
					<xsl:variable name="imageUrl">
						<xsl:call-template name="getImageSource">
							<xsl:with-param name="sourceValue" select="@image"/>
						</xsl:call-template>
					</xsl:variable>
					<div>
						<img src="{$imageUrl}" alt="Answer Model" class="answerModelImage"/>
					</div>
				</xsl:if>

				<div class="block">
					<p>
						<xsl:apply-templates/>
					</p>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="text()" mode="outputOpenGradableAnswerModel"/>

	<!-- output rcfCollapsibleBlock here as that code will handle the answer model display -->
	<xsl:template match="answerModel" mode="getUnmarkedInteractionName">
		rcfCollapsibleBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>
</xsl:stylesheet>
