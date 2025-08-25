<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
	Math - multiplication interaction

	outputs the interaction div placeholder and is populated by the javascript at runtime

-->

	<xsl:template match="mathsMultiplication">
		<xsl:variable name="outputDecimalNotation">
			<xsl:choose>
				<xsl:when test="not(@decimalNotation) or (@decimalNotation='')">.</xsl:when>
				<xsl:when test="@decimalNotation='comma'">,</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="showWorking">
			<xsl:choose>
				<xsl:when test="not(@showWorking) or (@showWorking='')">n</xsl:when>
				<xsl:when test="@showWorking='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>

		<div data-rcfInteraction="mathsMultiplication"
			data-rcfId="{@id}"
			class="{normalize-space(concat('mathsInteraction multiplication ', $exampleClass))}"
			data-rcfDecimalNotation="{$outputDecimalNotation}"
			data-rcfShowWorking="{$showWorking}"
		>
			<xsl:attribute name="data-rcfNumbers">
				<xsl:for-each select="./number">
					<xsl:sort select="text()" data-type="number" order="descending"/>
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</div>
	</xsl:template>

	<xsl:template match="mathsMultiplication" mode="getRcfClassName">
		rcfMathsMultiplication
	</xsl:template>

</xsl:stylesheet>
