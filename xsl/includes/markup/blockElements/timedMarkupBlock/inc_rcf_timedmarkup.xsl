<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="timedMarkupBlock">

		<div data-rcfinteraction="timedMarkupBlock"
			data-ignoreNextAnswer="y"
			class="{normalize-space(concat('timedMarkupBlock ', @initialClass, ' ', @class))}"
			data-duration="{@duration}"
			data-initialclass="{@initialClass}"
			data-activeclass="{@activeClass}"
			data-finalclass="{@finalClass}"
		>

			<div class="controlsContainer textControls">
				<a class="singleButton play" data-rcfTranslate="">[ components.button.start ]</a>
				<xsl:if test="@showRevealButton='y'">
					<a class="singleButton reveal" data-rcfTranslate="">[ components.button.reveal ]</a>
				</xsl:if>
				<span class="countDown"></span>
			</div>
			<div class="timedMarkupContent">
				<xsl:apply-templates />
			</div>

		</div>

	</xsl:template>

	<xsl:template match="timedMarkupBlock" mode="getUnmarkedInteractionName">
		rcfTimedMarkupBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
