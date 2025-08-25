<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		output the pelmanism html structure

	-->
	<xsl:template match="pelmanism">
		<xsl:variable name="numPairs">
			<xsl:choose>
				<xsl:when test="@numPairs"><xsl:value-of select="@numPairs"/></xsl:when>
				<xsl:otherwise>6</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="timedClass"><xsl:if test="@timeLimit">timed</xsl:if></xsl:variable>
		<xsl:variable name="pairClasses"><xsl:for-each select="cards/pair"><xsl:value-of select="@class"/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each></xsl:variable>

		<xsl:variable name="flipDelay">
			<xsl:choose>
				<xsl:when test="@flipBackDelay"><xsl:value-of select="@flipBackDelay"/></xsl:when>
				<xsl:otherwise>1200</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="pelmanismContainer {$timedClass} {@class}" data-rcfinteraction="pelmanism" data-rcfid="{@id}" data-numpairs="{$numPairs}" data-pairs="{$pairClasses}" data-flipbackdelay="{$flipDelay}" data-ignoreNextAnswer="y" >
			<xsl:if test="@timeLimit"><xsl:attribute name="data-timelimit"><xsl:value-of select="@timeLimit"/></xsl:attribute></xsl:if>
			<xsl:if test="@reorderAnswers='y'"><xsl:attribute name="data-reorderanswers"><xsl:value-of select="@reorderAnswers"/></xsl:attribute></xsl:if>
			<xsl:if test="not(@showAttempts) or @showAttempts='' or @showAttempts='y'">
				<div class="pelmanismAttempts">
					<span>
						<span class="attempts" data-rcfTranslate="">[ interactions.pelmanism.attempts ]</span><xsl:text> </xsl:text><span class="numAttempts">0</span>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="@timeLimit">
				<div class="pelmanismTimer">
					<span class="timer">00:00</span>
				</div>
			</xsl:if>
			<xsl:apply-templates select="cards"/>
			<div class="gameOverStage"></div>
			<xsl:if test="@reshuffleButton='y'">
				<div class="shuffleContainer">
					<button role="button" tabindex="0" class="button shuffleButton singleButton" data-rcfTranslate="" type="button">[ interactions.pelmanism.reshuffle ]</button>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="pelmanism/cards">
		<div class="cards clearfix">
			<xsl:for-each select="pair">
				<xsl:apply-templates />
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="pelmanism/cards/pair/card">
		<xsl:variable name="useClass">
			<xsl:if test="@class"><xsl:value-of select="@class"/> </xsl:if>
			<xsl:if test="@example"><xsl:value-of select="@example"/> </xsl:if>
		</xsl:variable>
		<xsl:variable name="pairClass"><xsl:value-of select="ancestor::pair/@class"/></xsl:variable>
		<xsl:variable name="cardId"><xsl:value-of select="ancestor::pelmanism/@id"/>_card_<xsl:value-of select="count(preceding::card)"/></xsl:variable>

		<div class="cardContainer {$pairClass}" data-cardorder="{count(preceding::card)}">
			<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>

			<div data-rcfid="card_{$cardId}" data-cardid="card_{$cardId}" class="card {$pairClass} {$useClass}" data-pairClass="{$pairClass}">
				<xsl:if test="@rank">
					<xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@audio">
					<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
				</xsl:if>
				<!-- back of card -->
				<div class="back"></div>
				<!-- front of card -->
				<div class="front">
					<!-- card contents -->
					<xsl:apply-templates/>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- rcf_pelmanism -->
	<xsl:template match="pelmanism" mode="getRcfClassName">
		rcfPelmanism
	</xsl:template>

</xsl:stylesheet>
