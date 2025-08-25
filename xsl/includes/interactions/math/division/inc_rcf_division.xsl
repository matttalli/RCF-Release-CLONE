<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
	Math - Division interaction

	outputs the interaction div placeholder and is populated by the javascript at runtime

-->

	<xsl:template match="mathsDivision">
		<xsl:variable name="outputDecimalNotation">
			<xsl:choose>
				<xsl:when test="not(@decimalNotation) or (@decimalNotation='')">.</xsl:when>
				<xsl:when test="@decimalNotation='comma'">,</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- extra checks for 'markRemainder' - if there are decimals then we can't guarantee the 'real' remainder for the user - so change it to 'n' -->
		<xsl:variable name="markRemainder">
			<xsl:choose>
				<xsl:when test="not(@markRemainder) or (@markRemainder='') or (@markRemainder='y' and @decimals &gt; 0)">n</xsl:when>
				<xsl:otherwise><xsl:value-of select="@markRemainder"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- always show working if markRemainder = 'y', but hide everything except remainder row -->
		<xsl:variable name="showWorking">
			<xsl:choose>
				<xsl:when test="$markRemainder = 'y' and (not(@showWorking) or (@showWorking=''))">y</xsl:when>
				<xsl:when test="$markRemainder = 'y' and @showWorking='n'">y</xsl:when>
				<xsl:when test="$markRemainder = 'n' and (not(@showWorking) or (@showWorking=''))">n</xsl:when>
				<xsl:when test="@showWorking='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="layout">
			<xsl:choose>
				<xsl:when test="not(@layout) or (@layout='')">english</xsl:when>
				<xsl:otherwise><xsl:value-of select="@layout"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="rounding">
			<xsl:choose>
				<xsl:when test="not(@rounding) or (@rounding='')">n</xsl:when>
				<xsl:otherwise><xsl:value-of select="@rounding"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="decimalPlaces">
			<xsl:choose>
				<xsl:when test="not(@decimals) or (@decimals='')">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="@decimals"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="layoutClass">layout-<xsl:value-of select="$layout"/></xsl:variable>

		<xsl:variable name="overrideClasses">
			<xsl:choose>
				<xsl:when test="$markRemainder='y' and (@showWorking='n' or (not(@showWorking) or (@showWorking='')))">onlyShowRemainderWorking</xsl:when>
				<!-- nothing else .. for now .. -->
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div data-rcfInteraction="mathsDivision"
			data-rcfId="{@id}"
			class="{normalize-space(concat('mathsInteraction division ', $layoutClass, ' ', $overrideClasses, ' ', $exampleClass))}"
			data-rcfDecimalNotation="{$outputDecimalNotation}"
			data-rcfShowWorking="{$showWorking}"
			data-rcfMarkRemainder="{$markRemainder}"
			data-rcfLayout="{$layout}"
			data-rcfRounding="{$rounding}"
			data-rcfDecimalPlaces="{$decimalPlaces}"
			data-rcfNumbers="{number[1]}|{number[2]}"
		>
			<!-- populated at runtime -->
		</div>
	</xsl:template>

	<xsl:template match="mathsDivision" mode="getRcfClassName">
		rcfMathsDivision
	</xsl:template>

</xsl:stylesheet>
