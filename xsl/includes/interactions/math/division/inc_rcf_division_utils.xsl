<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
	Division utils xsl templates - because these are shared with the html and print versions of the interactions

	Otherwise this same code to get the properties would be repeated in at least 3 places ... yuck

	Most likely, the majority of these could be used by all the maths interactions in a common template somewhere

	At the moment, this is only used by print xslt - we should really use it for the web version too (time permitting!)
-->

	<xsl:template name="getOutputDecimalNotation">
		<xsl:param name="decimalNotation"/>
		<xsl:choose>
			<xsl:when test="$decimalNotation='comma'">,</xsl:when>
			<xsl:otherwise>.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getMarkRemainder">
		<xsl:param name="markRemainder"/>
		<xsl:param name="decimals"/>
		<xsl:choose>
			<xsl:when test="not($markRemainder) or ($markRemainder='') or ($markRemainder='y' and $decimals &gt; 0)">n</xsl:when>
			<xsl:otherwise><xsl:value-of select="$markRemainder"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getShowWorking">
		<xsl:param name="markRemainder"/>
		<xsl:param name="showWorking"/>
		<xsl:choose>
			<xsl:when test="$markRemainder = 'y' and (not($showWorking) or ($showWorking=''))">y</xsl:when>
			<xsl:when test="$markRemainder = 'y' and $showWorking='n'">y</xsl:when>
			<xsl:when test="$markRemainder = 'n' and (not($showWorking) or ($showWorking=''))">n</xsl:when>
			<xsl:when test="$showWorking='y'">y</xsl:when>
			<xsl:otherwise>n</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLayout">
		<xsl:param name="layout"/>
		<xsl:choose>
			<xsl:when test="not($layout) or ($layout='')">english</xsl:when>
			<xsl:otherwise><xsl:value-of select="$layout"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getRounding">
		<xsl:param name="rounding"/>
		<xsl:choose>
			<xsl:when test="not($rounding) or ($rounding='')">n</xsl:when>
			<xsl:otherwise><xsl:value-of select="$rounding"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getDecimalPlaces">
		<xsl:param name="decimals"/>
		<xsl:choose>
			<xsl:when test="not($decimals) or ($decimals='')">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="$decimals"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getExampleClass">
		<xsl:param name="example"/>
		<xsl:choose>
			<xsl:when test="$example='y'">example</xsl:when>
			<xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLayoutClass">
		<xsl:param name="layout"/>
		layout-<xsl:value-of select="$layout"/>
	</xsl:template>

	<xsl:template name="getOverrideClasses">
		<xsl:param name="markRemainder"/>
		<xsl:param name="showWorkingAttribute"/>
		<xsl:choose>
			<xsl:when test="$markRemainder='y' and ($showWorkingAttribute='n' or (not($showWorkingAttribute) or ($showWorkingAttribute='')))">onlyShowRemainderWorking</xsl:when>
			<!-- nothing else .. for now .. -->
			<xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>
