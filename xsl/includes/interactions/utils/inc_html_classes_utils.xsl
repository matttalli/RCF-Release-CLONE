<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="elementContentStylingClasses">
		<xsl:param name="contentElement"/>
		<xsl:variable name="elementTextValue"><xsl:apply-templates select="$contentElement//text()"/></xsl:variable>
		<xsl:variable name="contentClasses">
			<xsl:if test="count($contentElement//image) + count($contentElement//imageAudio) &gt; 0">
				hasImage
			</xsl:if>
			<xsl:if test="count($contentElement//imageAudio) &gt; 0">
				hasImageAudio
			</xsl:if>
			<xsl:if test="count($contentElement//image/caption) + count($contentElement//imageAudio/caption) &gt; 0">
				hasImageCaption
			</xsl:if>
			<xsl:if test="count($contentElement//audio) &gt; 0">
				hasAudio
			</xsl:if>
			<xsl:if test="normalize-space($elementTextValue)!=''">
				hasText
			</xsl:if>
			<xsl:if test="count($contentElement//prompt) &gt; 0">
				hasPrompt
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="normalize-space($contentClasses)"/>
	</xsl:template>

	<xsl:template name="interactionContentStylingClasses">
		<xsl:param name="interactionElement"/>
		<xsl:variable name="contentClasses">
			<xsl:if test="count($interactionElement//image) + count($interactionElement//imageAudio) &gt; 0">
				hasImageAnswers
			</xsl:if>
			<xsl:if test="count($interactionElement//imageAudio) &gt; 0">
				hasImageAudioAnswers
			</xsl:if>
			<xsl:if test="count($interactionElement//image/caption) + count($interactionElement//imageAudio/caption) &gt; 0">
				hasImageCaptionAnswers
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="normalize-space($contentClasses)"/>
	</xsl:template>

	<xsl:template name="itemContentStylingClasses">
		<xsl:param name="itemElement"/>
		<xsl:variable name="contentClasses">
			<xsl:if test="count($itemElement//image) + count($itemElement//imageAudio) &gt; 0">
				imageAnswer
			</xsl:if>
			<xsl:if test="count($itemElement//imageAudio) &gt; 0">
				imageAudioAnswer
			</xsl:if>
			<xsl:if test="count($itemElement//image/caption) + count($itemElement//imageAudio/caption) &gt; 0">
				imageCaptionAnswer
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="normalize-space($contentClasses)"/>
	</xsl:template>

</xsl:stylesheet>
