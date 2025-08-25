<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--

		interactive image html structure

	-->

	<xsl:template match="interactiveImage[@type='' or not(@type)]">
		<xsl:variable name="imageSrc">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="@src"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'images'"/>
				<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>
		<div class="interactiveImageContainer" >
			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<div class="interactiveImage">
				<img src="{$imageSrc}" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="interactiveImage[@type='blur']">
		<xsl:variable name="imageSrc">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="@src"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'images'"/>
				<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>
		<div data-rcfinteraction="interactiveImage" data-ignoreNextAnswer="y" class="interactiveImageContainer blur0" data-type="blur">
			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<div class="interactiveImage blur">
				<img src="{$imageSrc}" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="interactiveImage[@type='timed']">
		<xsl:variable name="imageSrc">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="@src"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'images'"/>
				<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>
		<div class="interactiveImageContainer timed"
			data-rcfinteraction="interactiveImage"
			data-ignoreNextAnswer="y"
			data-type="timed"
			data-duration="{@duration}"
		>
			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<div class="interactiveImage">
				<img src="{$imageSrc}"/>
			</div>
			<div class="controlsContainer textControls">
				<center>
					<a class="singleButton play" data-rcfTranslate="">[ interactions.interactiveImage.flash ]</a>
					<a class="singleButton reveal" data-rcfTranslate="">[ interactions.interactiveImage.reveal ]</a>
				</center>
			</div>

		</div>

	</xsl:template>

	<xsl:template match="interactiveImage[@type='spotlight']">
		<xsl:variable name="imageSrc">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="@src"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'images'"/>
				<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>
		<center>
			<div data-rcfinteraction="interactiveImage" data-ignoreNextAnswer="y" class="interactiveImageContainer spotlight" data-type="spotlight" data-imagesrc="{$imageSrc}">
				<xsl:if test="@audio">
					<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
				</xsl:if>
				<div>
					<div class="reveal" data-rcfTranslate="">[ interactions.interactiveImage.reveal ]</div>
					<div class="torch spotlight">
					    <div class="ui-resizable-handle ui-resizable-nw nwgrip" id="nwgrip"></div>
					    <div class="ui-resizable-handle ui-resizable-ne negrip" id="negrip"></div>
					    <div class="ui-resizable-handle ui-resizable-sw swgrip" id="swgrip"></div>
					    <div class="ui-resizable-handle ui-resizable-se segrip" id="segrip"></div>
					    <div class="ui-resizable-handle ui-resizable-n ngrip" id="ngrip"></div>
					    <div class="ui-resizable-handle ui-resizable-s sgrip" id="sgrip"></div>
					    <div class="ui-resizable-handle ui-resizable-e egrip" id="egrip"></div>
					    <div class="ui-resizable-handle ui-resizable-w wgrip" id="wgrip"></div>
					</div>
					<img class="hidden" src="{$levelAssetsURL}/images/{@src}" />
				</div>
			</div>
		</center>
	</xsl:template>

	<xsl:template match="interactiveImage" mode="getUnmarkedInteractionName">
		rcfInteractiveImage
	</xsl:template>

</xsl:stylesheet>
