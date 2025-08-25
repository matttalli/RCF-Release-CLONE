<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- key for language lookups.... MEC only ? -->
	<xsl:key name="uniqueHintLanguages" match="hintBlock" use="@lang"/>
	<xsl:variable name="numberOfHintLanguages" select="count(//hintBlock[generate-id() = generate-id(key('uniqueHintLanguages', @lang)[1])])"/>

	<xsl:template match="hints[not(ancestor::multiPanel)]">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<!-- hint language is always unique - only one instance of each allowed ! -->
		<xsl:variable name="languages">
			<xsl:for-each select="hintBlock"><xsl:if test="@lang"><xsl:value-of select="@lang"/><xsl:if test="position()!=last()">|</xsl:if></xsl:if></xsl:for-each>
		</xsl:variable>
		<!-- RCF-3824 - wrap in collapsibleContainer and RCF js will take care of the rest -->
		<div data-rcfinteraction="collapsibleBlock" data-ignoreNextAnswer="y" class="collapsibleContainer hintCollapsibleContainer {@class}" data-initialopen="n">
			<span class="singleButton {$rippleClass} collapsibleButton">
				<span class="whenOpened" data-rcfTranslate="">[ interactions.hints.whenOpened ]</span>
				<span class="whenClosed" data-rcfTranslate="">[ interactions.hints.whenClosed ]</span>
			</span>

			<div class="block collapsibleTargetBlock hintsContainer {@class}">
				<xsl:if test="$languages!=''"><xsl:attribute name="data-languages"><xsl:value-of select="$languages"/></xsl:attribute></xsl:if>
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="hintBlock">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<xsl:variable name="currentClass"><xsl:if test="@lang"><xsl:if test="count(preceding-sibling::hintBlock)=0">current</xsl:if></xsl:if></xsl:variable>
		<xsl:variable name="langClass"><xsl:if test="@lang">mm_lang_<xsl:value-of select="@lang"/></xsl:if></xsl:variable>
		<xsl:variable name="nextLanguage">
			<xsl:choose>
				<xsl:when test="count(following-sibling::hintBlock) > 0"><xsl:value-of select="following-sibling::hintBlock/@lang"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="ancestor::hints/hintBlock[1]/@lang"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="hintBlock {$langClass} {$currentClass}">
			<xsl:if test="@lang and $numberOfHintLanguages &gt; 1">
				<xsl:attribute name="data-lang"><xsl:value-of select="@lang"/></xsl:attribute>
				<span class="singleButton {$rippleClass} toggleLanguageButton" data-switchToLanguage="{$nextLanguage}"><xsl:value-of select="$nextLanguage"/></span>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="hints" mode="getUnmarkedInteractionName">
		rcfHints
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
