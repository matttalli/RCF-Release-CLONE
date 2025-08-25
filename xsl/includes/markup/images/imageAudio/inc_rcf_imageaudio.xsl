<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="imageAudio">
		<xsl:variable name="containerClass">imageAudio <xsl:if test="./caption">imageContainer imageCaption </xsl:if><xsl:value-of select="@class"/></xsl:variable>
		<span
			data-rcfinteraction="imageAudio"
			data-ignoreNextAnswer="y"
			class="{normalize-space($containerClass)}"
			data-audiolink="{@audio}"
			tabindex="0"
		>
			<xsl:variable name="imageAudioImageSrc">
				<xsl:call-template name="getAssetSource">
					<xsl:with-param name="assetSource" select="@src"/>
					<xsl:with-param name="useEnvironment" select="$environment"/>
					<xsl:with-param name="assetPartialPathName" select="'images'"/>
					<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
				</xsl:call-template>
			</xsl:variable>
			<img src="{$imageAudioImageSrc}" title="{@title}" alt="{@a11yTitle}">
				<xsl:if test="@a11yTitleLang">
					<xsl:attribute name="lang"><xsl:value-of select="@a11yTitleLang"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@decorative='y'">
					<xsl:attribute name="role">presentation</xsl:attribute>
				</xsl:if>
				<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			</img>
			<xsl:if test="caption">
				<span class="caption {./caption/@type}">
					<xsl:if test="./caption/@lang">
						<xsl:attribute name="lang">
							<xsl:value-of select="./caption/@lang"/>
						</xsl:attribute>
					</xsl:if>

					<span class="innerCaption">
						<xsl:apply-templates/>
					</span>
				</span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="imageAudio" mode="getUnmarkedInteractionName">
		rcfImageAudio
	</xsl:template>

</xsl:stylesheet>
