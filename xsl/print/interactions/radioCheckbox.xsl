<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	radio & checkbox template / transformation

-->
	<xsl:template match="radio[@isInteraction='y'] | checkbox[@isInteraction='y']">
		<xsl:variable name="exampleClassName"><xsl:if test="@example='y'"> rcfPrint-example</xsl:if></xsl:variable>
		<xsl:variable name="hasImageClassName"><xsl:if test="descendant::image or descendant::imageAudio"> rcfPrint-hasImages</xsl:if></xsl:variable>
		<div class="{normalize-space(concat(@printClass, $exampleClassName, $hasImageClassName))}" data-rcfid="{@id}">
			<xsl:call-template name="outputPrintNumber"/>
			<ol type="a">
				<xsl:apply-templates/>
			</ol>
		</div>
	</xsl:template>

	<xsl:template match="radio[@isInteraction='y']/item | checkbox[@isInteraction='y']/item">
		<xsl:variable name="className">rcfPrint-item <xsl:if test="(../@example='y' or @example='y') and @correct='y'">rcfPrint-correct</xsl:if></xsl:variable>
		<xsl:variable name="itemIndex"><xsl:value-of select="count(preceding-sibling::item)+1"/></xsl:variable>
		<xsl:variable name="itemCharacter"><xsl:value-of select="substring($lowercaseIndex, $itemIndex, 1)"/></xsl:variable>
		<li class="{normalize-space($className)}" data-rcfid="{@id}">
			<span class="rcfPrint-text">
				<span class="rcfPrint-itemNumber"><xsl:value-of select="$itemCharacter" /></span>
				<xsl:apply-templates/>
			</span>
			<!-- <xsl:if test="count(following-sibling::item)>0">
				<xsl:call-template name="outputPrintSeparator"/>
			</xsl:if> -->
		</li>
	</xsl:template>

	<!--- answer key output -->
	<xsl:template match="radio[@isInteraction='y'] | checkbox[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer <xsl:if test="@example='y'">rcfPrint-example</xsl:if></xsl:variable>

		<xsl:if test="not(@example='y')">
			<span class="{normalize-space($className)}" data-rcfid="{@id}">
				<xsl:apply-templates mode="outputAnswerKey"/>
			</span>
		</xsl:if>

	</xsl:template>

	<xsl:template match="radio[@isInteraction='y']/item[@correct='y'] | checkbox[@isInteraction='y']/item[@correct='y']" mode="outputAnswerKey">
		<xsl:variable name="answerIndex"><xsl:value-of select="count(preceding-sibling::item)+1"/></xsl:variable>
		<xsl:variable name="answerCharacter"><xsl:value-of select="substring($lowercaseIndex, $answerIndex, 1)"/></xsl:variable>

		<xsl:if test="not(../@example='y') and not(@example='y')">
			<span class="rcfPrint-item" data-rcfid="{@id}">
				<xsl:value-of select="$answerCharacter"/>
				<xsl:if test="following-sibling::item[@correct='y']"><xsl:call-template name="outputAnswerKeyPrintSeparator"/></xsl:if>
			</span>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
