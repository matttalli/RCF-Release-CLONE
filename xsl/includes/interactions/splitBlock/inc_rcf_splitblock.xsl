<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="splitBlock">
		<!-- if wordboxposition='top', it will already have been written out ! -->
		<xsl:if test="$wordBoxPosition='default'">
			<xsl:if test="(count(ancestor::activity//droppable) + count(ancestor::activity//complexDroppable)) > 0">
				<xsl:call-template name="standardWordBox">
					<xsl:with-param name="activity" select="ancestor::activity"/>
					<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
					<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<div
			data-rcfinteraction="splitBlock"
			data-ignoreNextAnswer="y"
			data-rcfInitialisePriority="-1"
			class="{normalize-space(concat('splitScreenBlock firstPanelOpen secondPanelOpen clearfix', ' ', @class))}"
		>
			<div class="block panelOneContainer">
				<xsl:apply-templates select="block[1]"/>
			</div>
			<div class="splitControls">
				<span class="singleButton secondPanel"></span><span class="singleButton firstPanel"></span>
			</div>
			<div class="block panelTwoContainer">
				<xsl:apply-templates select="block[2]"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="splitBlock" mode="getUnmarkedInteractionName">
		rcfSplitBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
