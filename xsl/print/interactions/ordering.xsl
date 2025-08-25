<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="ordering[@isInteraction='y']">
		<xsl:variable name="exampleClass">
			<xsl:if test="./@example='y'"> rcfPrint-example</xsl:if>
		</xsl:variable>
		<ul class="{normalize-space(concat('rcfPrint-ordering', $exampleClass))}" data-rcfid="{@id}">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="ordering[@isInteraction='y']/item">
		<xsl:variable name="itemId" select="@id"/>
		<xsl:variable name="correctItem" select="ancestor::ordering/correctOrder/item[@id=$itemId]"/>

		<li class="rcfPrint-item" data-rcfid="{@id}">
			<xsl:if test="@rank">
				<xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="mediaClass">
				<xsl:choose>
					<xsl:when test="child::image">rcfPrint-image</xsl:when>
					<xsl:when test="child::imageAudio">rcfPrint-imageAudio</xsl:when>
					<xsl:otherwise>rcfPrint-text</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<span class="{$mediaClass}">
				<xsl:apply-templates />
			</span>
			<span class="rcfPrint-wol">
				<xsl:if test="../@example='y'">
					<xsl:value-of select="@order"/>
				</xsl:if>
			</span>
		</li>
	</xsl:template>

	<xsl:template match="ordering[@isInteraction='y']/suffix">
		<li class="rcfPrint-suffix">
			<xsl:variable name="mediaClass">
				<xsl:choose>
					<xsl:when test="child::image">rcfPrint-image</xsl:when>
					<xsl:when test="child::imageAudio">rcfPrint-imageAudio</xsl:when>
					<xsl:otherwise>rcfPrint-text</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<span class="{$mediaClass}">
				<xsl:apply-templates/>
			</span>
			<span />
		</li>
	</xsl:template>

	<xsl:template match="ordering[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
		<xsl:if test="not(./@example='y')">
			<span class="rcfPrint-ordering rcfPrint-answer" data-rcfid="{@id}">
				<xsl:apply-templates mode="outputAnswerKeyValueForInteraction" />
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ordering[@isInteraction='y']/item" mode="outputAnswerKeyValueForInteraction">
		<xsl:if test="not(../@example='y')">
			<span class="rcfPrint-item" data-rcfid="{@id}">
				<xsl:value-of select="@order"/>
				<xsl:if test="count(following-sibling::item)>0">
					<span class="rcfPrint-separator">/</span>
				</xsl:if>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ordering[@isInteraction='y']/suffix" mode="outputAnswerKeyValueForInteraction">
		<!-- Don't output anything for the suffix -->
	</xsl:template>

</xsl:stylesheet>
