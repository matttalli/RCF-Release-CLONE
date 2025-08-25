<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="prompt" >
		<xsl:variable name="extraPromptClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('prompt ', @class, ' ', $extraPromptClasses))}">
			<xsl:apply-templates/>
		</div>

	</xsl:template>

	<xsl:template match="balloonsGame/questions/question/prompt">
		<xsl:variable name="extraPromptClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('prompt balloonQuestionPrompt ', @class, ' ', $extraPromptClasses))}" data-rcfid="{../@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="findInImage/questions/question/prompt">
		<xsl:variable name="extraPromptClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="svgAnswers">
			<xsl:for-each select="ancestor::question/item">
				<xsl:value-of select="@id"/>
				<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<div class="{normalize-space(concat('prompt findInImageQuestionPrompt ', @class, ' ', $extraPromptClasses))}" data-rcfid="{ancestor::question/@id}" data-answers="{$svgAnswers}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="sequenceTileMaze/questions/question/prompt">
		<xsl:variable name="extraPromptClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('prompt tileMazePrompt ', @class, ' ', $extraPromptClasses))}" data-rcfid="{../@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="categoriseTileMaze/questions/question/prompt">
		<xsl:variable name="extraPromptClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('prompt tileMazePrompt ', @class, ' ', $extraPromptClasses))}" data-rcfid="{../@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>
