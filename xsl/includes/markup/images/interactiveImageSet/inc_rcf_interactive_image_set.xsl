<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="interactiveImageSet">
		<xsl:variable name="interactiveImageSetType">
			<xsl:choose>
				<xsl:when test="not(@type='')"><xsl:value-of select="@type"/></xsl:when>
				<xsl:otherwise>zoom</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div data-rcfinteraction="interactiveImageSet"
			data-ignoreNextAnswer="y"
			class="{normalize-space(concat('interactiveImageSet  clearfix ', $interactiveImageSetType, ' ', @class))}"
			data-interactiontype="{$interactiveImageSetType}">
			<div class="imageSetMask rcfInteractiveMask"></div>
			<div class="closeImageButton"></div>
			<ul class="images">
				<xsl:apply-templates/>
			</ul>
		</div>

	</xsl:template>

	<xsl:template match="interactiveImageSet/image">
		<li>
			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="targetSrc">
				<xsl:choose>
					<xsl:when test="@largeImageSrc"><xsl:value-of select="@largeImageSrc"></xsl:value-of></xsl:when>
					<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="targetPathedSrc">
				<xsl:call-template name="getAssetSource">
					<xsl:with-param name="assetSource" select="$targetSrc"/>
					<xsl:with-param name="useEnvironment" select="$environment"/>
					<xsl:with-param name="assetPartialPathName" select="'images'"/>
					<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
				</xsl:call-template>
			</xsl:variable>
			<span class="imageContainer interactiveImageContainer" data-mfp-src="{$targetPathedSrc}" >
				<xsl:variable name="imageSrc">
					<xsl:call-template name="getAssetSource">
						<xsl:with-param name="assetSource" select="@src"/>
						<xsl:with-param name="useEnvironment" select="$environment"/>
						<xsl:with-param name="assetPartialPathName" select="'images'"/>
						<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
					</xsl:call-template>
				</xsl:variable>

				<img src="{$imageSrc}" title="{@title}" alt="{@a11yTitle}">
					<xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
				</img>

				<xsl:if test="count(caption)>0">
					<span class="caption {./caption/@type}">
						<span class="innerCaption">
							<xsl:apply-templates/>
						</span>
					</span>
				</xsl:if>
			</span>
		</li>
	</xsl:template>

	<xsl:template match="interactiveImageSet" mode="getUnmarkedInteractionName">
		rcfInteractiveImageSet
	</xsl:template>

</xsl:stylesheet>
