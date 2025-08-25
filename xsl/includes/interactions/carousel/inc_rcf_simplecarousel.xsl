<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="simpleCarousel">
		<xsl:variable name="numItems">
			<xsl:choose>
				<xsl:when test="not(@numItems)">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="@numItems"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="resetTriggers">
			<xsl:choose>
				<xsl:when test="not(@resetTriggers)">n</xsl:when>
				<xsl:otherwise><xsl:value-of select="@resetTriggers"></xsl:value-of></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div data-rcfinteraction="simpleCarousel"
			data-ignoreNextAnswer="y"
			class="rcfCarousel simple owl-carousel owl-theme {@class}"
			data-autoheight="n"
			data-numitems="{$numItems}"
			data-resettriggers="{$resetTriggers}"
			data-rcfInitialisePriority="1"
		>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="simpleCarousel" mode="getUnmarkedInteractionName">
		rcfSimpleCarousel
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
