<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- sliding block ... **NOT** the one inside <multiPanel> -->
	<xsl:template match="slidingBlock">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>
		<xsl:variable name="buttonClasses">
			<xsl:value-of select="normalize-space(concat('singleButton ', $rippleClass, ' slidingButton'))"/>
		</xsl:variable>
		<xsl:variable name="slidingBlockId">
			<xsl:call-template name="generateId">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div data-rcfinteraction="slidingBlock" data-ignoreNextAnswer="y" class="slidingContainer">
			<!-- output button to trigger the panel appearing -->
			<xsl:choose>
				<xsl:when test="slidingButton/@caption=''">
					<span class="{$buttonClasses}" data-rcfTranslate="">[ interactions.slidingBlock.buttonCaption ]</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="{$buttonClasses}"
						role="button"
						aria-haspopup="dialog"
						tabindex="0"
					>
						<xsl:value-of select="slidingButton/@caption"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>

			<div id="{$slidingBlockId}" class="slidingBlock from-{@slideFrom}" role="dialog" aria-modal="true" tabindex="-1">
				<header class="slidingHeader">
					<h1><xsl:value-of select="slidingPanelTitle"/></h1>
					<span class="slidingButtonClose"
						role="button"
						aria-controls="{$slidingBlockId}"
						tabindex="0"
						data-rcfTranslate=""
					>[ interactions.slidingPanel.close ]</span>
				</header>

				<article class="slidingPanel">
					<div class="slidingContent block">
						<xsl:apply-templates select="block"/>
					</div>
				</article>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="slidingBlock" mode="getUnmarkedInteractionName">
		rcfSlidingBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
