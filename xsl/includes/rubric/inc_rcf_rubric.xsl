<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- key for language lookups.... MEC only ? -->
	<xsl:key name="uniqueRubricLanguages" match="rubric" use="@lang"/>

	<xsl:variable name="numberOfRubricLanguages" select="count(//rubric[generate-id() = generate-id(key('uniqueRubricLanguages', @lang)[1])])"/>
	<!--
		output the rubric html structure(s)
	-->
	<xsl:template name="outputRubrics">

		<xsl:variable name="languages">
			<xsl:for-each select="//rubric[generate-id() = generate-id(key('uniqueRubricLanguages', @lang)[1])]"><xsl:value-of select="@lang"/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each>
		</xsl:variable>

		<xsl:variable name="rubricChildContentClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="//rubric"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('rubricContainer ', $rubricChildContentClasses))}" >
			<xsl:if test="$numberOfRubricLanguages &gt; 1">
				<xsl:attribute name="data-languages"><xsl:value-of select="$languages"></xsl:value-of></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="//rubric" mode="outputRubrics"/>
		</div>
	</xsl:template>

	<xsl:template match="rubric" mode="outputRubrics">
		<xsl:variable name="currentClass"><xsl:if test="@lang"><xsl:if test="count(preceding-sibling::rubric)=0">current</xsl:if></xsl:if></xsl:variable>

		<xsl:variable name="nextLanguage">
			<xsl:choose>
				<xsl:when test="boolean(following-sibling::rubric)"><xsl:value-of select="following-sibling::rubric/@lang"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="preceding-sibling::rubric[1]/@lang"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="languageClass"><xsl:if test="@lang">mm_lang_<xsl:value-of select="@lang"/></xsl:if></xsl:variable>

		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<div class="{normalize-space(concat('rubric clearfix ', $languageClass, ' ', $currentClass))}">
			<xsl:if test="@lang and $numberOfRubricLanguages &gt; 1">
				<xsl:attribute name="data-lang"><xsl:value-of select="@lang"/></xsl:attribute>
				<span class="{normalize-space(concat('singleButton', ' ', $rippleClass, ' ', 'toggleLanguageButton'))}" data-switchToLanguage="{$nextLanguage}"><xsl:value-of select="$nextLanguage"/></span>
			</xsl:if>
			<xsl:apply-templates select="audio"/>
			<div class="rubricBody">
				<xsl:apply-templates select="*[not(local-name()='audio')]"/>
			</div>
		</div>

	</xsl:template>

	<!-- stop any <xsl:apply-templates/> causing text or other child nodes from the rubric to be output -->
	<xsl:template match="rubric"/>

	<!-- stop any <xsl:apply-templates/> outputting the <printRubric> element as that's only to be output by the assessment / print stylesheet -->
	<xsl:template match="printRubric"/>

</xsl:stylesheet>
