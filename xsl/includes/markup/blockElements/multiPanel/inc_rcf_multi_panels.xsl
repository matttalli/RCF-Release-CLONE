<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- multipanel blocks -->
	<xsl:template match="multiPanel">
		<div class="block multiPanels clearfix {@class}" >
			<div data-rcfinteraction="collapsibleBlock" data-ignoreNextAnswer="y" class="collapsibleContainer" data-initialopen="n">
				<!-- output buttons / clickable bits -->
				<xsl:apply-templates mode="outputMultiPanelButton"/>
				<!-- output the content blocks to be shown / hidden when buttons clicked -->
				<xsl:apply-templates mode="outputMultiPanelBlocks"/>
			</div>
		</div>
	</xsl:template>

	<!-- override standard hints template if inside a multipanel -->
	<xsl:template match="multiPanel/hints" mode="outputMultiPanelButton">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<xsl:if test="count(ancestor::multiPanel/collapsibleBlock) &gt; 0">
			<xsl:comment>the multiPanel cannot contain hints and collapsibleBlock elements together</xsl:comment>
		</xsl:if>

		<xsl:if test="count(ancestor::multiPanel/collapsibleBlock) = 0">
			<div class="hintsButtonContainer">
				<span class="singleButton {$rippleClass} collapsibleButton">
					<span class="whenOpened" data-rcfTranslate="">[ interactions.hints.whenOpened ]</span>
					<span class="whenClosed" data-rcfTranslate="">[ interactions.hints.whenClosed ]</span>
				</span>
			</div>
		</xsl:if>

	</xsl:template>

	<!-- output hint blocks -->
	<xsl:template match="multiPanel/hints" mode="outputMultiPanelBlocks">
		<xsl:variable name="hintsClass" select="@class"/>
		<xsl:variable name="languages">
			<xsl:for-each select="hintBlock"><xsl:if test="@lang"><xsl:value-of select="@lang"/><xsl:if test="position()!=last()">|</xsl:if></xsl:if></xsl:for-each>
		</xsl:variable>
		<xsl:if test="count(ancestor::multiPanel/collapsibleBlock) = 0">
			<div class="multiPanelHintsContainer collapsibleTargetBlock block hintsContainer {$hintsClass}">
				<xsl:if test="$languages!=''"><xsl:attribute name="data-languages"><xsl:value-of select="$languages"/></xsl:attribute></xsl:if>
				<xsl:apply-templates select="hintBlock"/>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- output sliding block button *and* content -->
	<xsl:template match="multiPanel/slidingBlock" mode="outputMultiPanelButton">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<xsl:variable name="slidingBlockId">
			<xsl:call-template name="generateId">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div data-rcfinteraction="slidingBlock" data-ignoreNextAnswer="y" class="slidingContainer">
			<!-- output button to trigger the panel appearing -->
			<span class="singleButton {$rippleClass} slidingButton"
				role="button"
				aria-haspopup="dialog"
				tabindex="0"
			>
				<xsl:value-of select="slidingButton/@caption"/>
			</span>

			<div id="{$slidingBlockId}" class="slidingBlock from-{@slideFrom}" role="dialog" aria-modal="true" tabindex="-1">
				<header class="slidingHeader">
					<h1><xsl:value-of select="slidingPanelTitle"/></h1>
					<span class="slidingButtonClose"
					role="button"
					aria-controls="{$slidingBlockId}"
					tabindex="0"
					data-rcfTranslate="">[ interactions.slidingPanel.close ]</span>
				</header>

				<article class="slidingPanel">
					<div class="slidingContent block">
						<xsl:apply-templates select="block"/>
					</div>
				</article>
			</div>

		</div>
	</xsl:template>

	<!-- sliding block content is output with the button - so ignored here -->
	<xsl:template match="multiPanel/slidingBlock" mode="outputMultiPanelBlocks"/>

	<!-- output collapsible block button -->
	<xsl:template match="multiPanel/collapsibleBlock" mode="outputMultiPanelButton">

		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<xsl:variable name="childBlockId">
			<xsl:call-template name="generateId">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="ariaExpandedValue">
			<xsl:choose>
				<xsl:when test="@open='y'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div data-rcfinteraction="slidingBlock" data-ignoreNextAnswer="y" class="slidingContainer collapsibleButtonContainer">
			<span class="{normalize-space(concat('singleButton slidingButton collapsibleButton ', $rippleClass))}"
				role="button"
				aria-expanded="{$ariaExpandedValue}"
				aria-controls="{$childBlockId}"
				tabindex="0"
			>
				<xsl:choose>
					<xsl:when test="collapseButton/@captionWhenOpened=''">
						<span class="whenOpened innerButtonCaption" data-rcfTranslate="" >[ interactions.collapsibleBlock.whenOpened ]</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="whenOpened innerButtonCaption">
							<xsl:value-of select="collapseButton/@captionWhenOpened"/>
						</span>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="collapseButton/@captionWhenClosed=''">
						<span class="whenClosed innerButtonCaption" data-rcfTranslate="">[ interactions.collapsibleBlock.whenClosed ]</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="whenClosed innerButtonCaption">
							<xsl:value-of select="collapseButton/@captionWhenClosed"/>
						</span>
					</xsl:otherwise>
				</xsl:choose>

			</span>
		</div>

	</xsl:template>

	<!-- output collapsible block content -->
	<xsl:template match="multiPanel/collapsibleBlock" mode="outputMultiPanelBlocks">
		<xsl:variable name="childBlockId">
			<xsl:call-template name="generateId">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div class="multiPanelCollapsibleContainer collapsibleTargetBlock block {@class}" data-rcfid="{@id}" data-initialopen="{@open}" id="{@childBlockId}">
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>

	</xsl:template>

	<xsl:template match="multiPanel" mode="getUnmarkedInteractionName">
		rcfMultiPanel
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
