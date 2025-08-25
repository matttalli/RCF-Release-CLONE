<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>

	<xsl:template match="wordSnake">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="interactive">
			<xsl:choose>
				<xsl:when test="@example='y'">n</xsl:when>
				<xsl:when test="not(@interactive='n')">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div data-rcfinteraction="wordsnake"
			class="{normalize-space(concat('wordSnakeContainer ', $exampleClass))}"
			data-interactive="{$interactive}"
			data-rcfid="{@id}" >

			<xsl:attribute name="data-draggable">
				<xsl:choose>
					<xsl:when test="ancestor::activity/@desktopDraggable='n'">n</xsl:when>
					<xsl:when test="@clickStick='y'">n</xsl:when>
					<xsl:otherwise>y</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<ul class="{normalize-space(concat('wordSnake ', $exampleClass))}" id="wordSnake_{@id}" >
				<xsl:for-each select="words/word">
					<xsl:variable name="precedingWordString"><xsl:for-each select="preceding-sibling::word"><xsl:value-of select="."/></xsl:for-each></xsl:variable>
					<xsl:call-template name="lettersFromWordSnakeWord">
						<xsl:with-param name="text" select="."/>
						<xsl:with-param name="letterCount" select="string-length($precedingWordString)+1"/>
						<xsl:with-param name="wordSnakeID" select="ancestor::wordSnake/@id"/>
						<xsl:with-param name="wordID" select="@id"/>
						<xsl:with-param name="wordExample"><xsl:if test="@example='y'">example</xsl:if></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</div>

	</xsl:template>

	<xsl:template name="lettersFromWordSnakeWord">
		<xsl:param name="text" />
		<xsl:param name="letterCount" select="'1'"/>
		<xsl:param name="wordSnakeID" />
		<xsl:param name="wordID"/>
		<xsl:param name="wordExample"/>

		<xsl:variable name="isDistractor"><xsl:if test="ancestor::activity//wordSnake[@id=$wordSnakeID]//word[@id=$wordID]/@distractor='y'">y</xsl:if></xsl:variable>

		<xsl:variable name="distractorClass">
			<xsl:if test="$isDistractor='y'">distractor</xsl:if>
		</xsl:variable>

		<xsl:if test="$text!=''">
			<xsl:variable name="letter" select="substring($text, 1, 1)"/>
 			<li class="{normalize-space(concat('letter ',$wordExample,' ', $distractorClass))}" id="{$wordSnakeID}_L{$letterCount}" data-distractor="{$isDistractor}" data-wordid="{$wordID}"><xsl:value-of select="$letter"/></li>
 			<xsl:call-template name="lettersFromWordSnakeWord">
				<xsl:with-param name="text" select="substring-after($text, $letter)"/>
				<xsl:with-param name="wordSnakeID" select="$wordSnakeID"/>
				<xsl:with-param name="wordID" select="$wordID"/>
				<xsl:with-param name="wordExample" select="$wordExample"/>
				<xsl:with-param name="letterCount" select="$letterCount+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- rcf_wordsnake -->
	<xsl:template match="wordSnake" mode="getRcfClassName">
		rcfWordSnake
	</xsl:template>

</xsl:stylesheet>
