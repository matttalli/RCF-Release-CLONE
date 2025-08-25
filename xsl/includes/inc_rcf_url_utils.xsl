<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- -->
	<xsl:template name="getAudioSource">
        <xsl:param name="sourceValue"/>
        <xsl:call-template name="getAssetSource">
            <xsl:with-param name="assetSource" select="$sourceValue"/>
            <xsl:with-param name="useEnvironment" select="$environment"/>
            <xsl:with-param name="assetPartialPathName" select="'audio'"/>
            <xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="getImageSource">
        <xsl:param name="sourceValue"/>
        <xsl:call-template name="getAssetSource">
            <xsl:with-param name="assetSource" select="$sourceValue"/>
            <xsl:with-param name="useEnvironment" select="$environment"/>
            <xsl:with-param name="assetPartialPathName" select="'images'"/>
            <xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
        </xsl:call-template>
	</xsl:template>

	<xsl:template name="getAssetSource">
		<xsl:param name="assetSource"/>
		<xsl:param name="assetPartialPathName" select="'images'"/>
		<xsl:param name="useEnvironment" />
		<xsl:param name="useAssetsUrl" />

		<xsl:choose>
			<xsl:when test="$useEnvironment='capePreview'">
				<xsl:value-of select="$assetSource"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$useAssetsUrl"/>/<xsl:value-of select="$assetPartialPathName"/>/<xsl:value-of select="$assetSource"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
