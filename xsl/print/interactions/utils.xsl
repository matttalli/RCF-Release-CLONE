<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template name="getInteractionNumber">
		<xsl:value-of select="count(preceding::*[@isInteraction='y']) + 1 - count(preceding::*[@isInteraction='y' and @example='y'])"/>
	</xsl:template>

	<xsl:template name="outputPrintNumber">
		<xsl:if test="(not(ancestor::li) and not(@example='y')) and (not(ancestor::li) and not(ancestor::*[@example='y'])) and not(count(preceding::*[@isInteraction='y' and not(@example='y')])=0 and count(following::*[@isInteraction='y' and not(@example='y')])=0)">
			<span class="rcfPrint-number">(<xsl:call-template name="getInteractionNumber"/>)<xsl:text> </xsl:text></span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="outputPrintSeparator">
		<span class="rcfPrint-separator">/</span>
	</xsl:template>

	<xsl:template name="outputAnswerKeyPrintSeparator">
		<xsl:variable name="separator">
			<xsl:choose>
				<xsl:when test="ancestor::checkbox">&amp;</xsl:when>
				<xsl:otherwise>/</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span class="rcfPrint-separator"><xsl:value-of select="$separator"/></span>
	</xsl:template>

	<xsl:template name="getLongestItem">
		<xsl:param name="items"/>
		<xsl:for-each select="$items">
			<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
			<xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
