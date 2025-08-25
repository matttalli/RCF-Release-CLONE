<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="mathsSubtraction[@isInteraction='y']">
		<xsl:variable name="outputDecimalNotation">
			<xsl:choose>
				<xsl:when test="not(@decimalNotation) or (@decimalNotation='')">.</xsl:when>
				<xsl:when test="@decimalNotation='comma'">,</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>

		<div
			data-rcfInteraction="mathsSubtraction"
			data-rcfid="{@id}"
			data-rcfDecimalNotation="{$outputDecimalNotation}"
			class="{normalize-space(concat(@printClass, ' mathsInteraction subtraction ', $exampleClass))}"
		>
			<xsl:attribute name="data-rcfNumbers">
				<xsl:for-each select="./number">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
			<xsl:comment>Subtraction interaction populated here</xsl:comment>
		</div>
	</xsl:template>

	<xsl:template match="mathsSubtraction[@isInteraction='y' and not(@example='y')]" mode="outputAnswerKeyValueForInteraction">
		<!--  this will ouput a div that gets populated by the js to output the full interaction in the answer key ...
		<div class="mathsInteraction subtraction example" data-rcfid="{@id}-answerKey" data-rcfInteraction="mathsSubtraction">
			<xsl:attribute name="data-rcfNumbers">
				<xsl:for-each select="./number">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</div>
		-->
		<xsl:variable name="outputDecimalNotation">
			<xsl:choose>
				<xsl:when test="not(@decimalNotation) or (@decimalNotation='')">.</xsl:when>
				<xsl:when test="@decimalNotation='comma'">,</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="outputFormat">##########.##########</xsl:variable>

		<xsl:variable name="calculatedAnswer">
			<xsl:value-of select="format-number(((number[1] * 2) - sum(./number) ), $outputFormat)"/>
		</xsl:variable>

		<xsl:variable name="answerValue">
			<xsl:choose>
				<xsl:when test="$calculatedAnswer &lt; 1 and $calculatedAnswer &gt; 0">0<xsl:value-of select="$calculatedAnswer"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$calculatedAnswer"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each select="number">
			<xsl:variable name="currentValue">
				<xsl:value-of select="translate(., '.', $outputDecimalNotation)"/>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test=". &lt; 1 and . &gt; 0 and not(substring($currentValue, 1,1)='0')">0<xsl:value-of select="$currentValue"/></xsl:when>
				<xsl:when test=". &lt; 0">(<xsl:value-of select="$currentValue"/>)</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentValue"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position() != last()"> - </xsl:if>
		</xsl:for-each> = <b><xsl:value-of select="$answerValue"/></b>
	</xsl:template>

	<xsl:template match="mathsSubtraction/number" mode="outputAnswerKeyValueForInteraction"/>

</xsl:stylesheet>
