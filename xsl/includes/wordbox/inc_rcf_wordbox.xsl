<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="./inc_rcf_wordbox_distractors.xsl"/>
	<xsl:import href="./inc_rcf_wordbox_droppables.xsl"/>
	<xsl:import href="./inc_rcf_wordbox_complexDroppables.xsl"/>

	<!-- output wordbox for the passed activity node and className -->
	<xsl:template name="standardWordBox">
		<xsl:param name="activity"/>
		<xsl:param name="className" />
		<xsl:param name="useFixedWordPools"/>
		<xsl:param name="useCollapsibleWordPools"/>

		<xsl:variable name="standardWordBoxClassValue">
			<xsl:call-template name="standardWordBoxClasses">
				<xsl:with-param name="className" select="$className"/>
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
				<xsl:with-param name="useCollapsibleWordPools" select="$useCollapsibleWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{$standardWordBoxClassValue}">
			<xsl:if test="$useCollapsibleWordPools='y'">
				<xsl:call-template name="outputCollapsibleToggleButton"/>
				<xsl:call-template name="outputCollapsiblePreviousItemButton"/>
			</xsl:if>

			<!-- output the list of word items -->
			<ul>
				<!-- output any activity level distractors -->
				<xsl:apply-templates select="$activity//main/distractors" mode="wordBoxOutput"/>
				<!-- output any non-example droppable items -->
				<xsl:apply-templates select="$activity//droppable[not(@example='y')]" mode="wordBoxOutput"/>
				<!-- output complex droppables - rule handling in that template -->
				<xsl:apply-templates select="$activity//complexDroppables/item" mode="wordBoxOutput"/>
			</ul>

			<xsl:if test="$useCollapsibleWordPools='y'">
				<xsl:call-template name="outputCollapsibleNextItemButton"/>
			</xsl:if>

		</div>

	</xsl:template>

	<xsl:template name="standardWordBoxClasses">
		<xsl:param name="className"/>
		<xsl:param name="useFixedWordPools"/>
		<xsl:param name="useCollapsibleWordPools"/>
		<xsl:variable name="fixedWordBoxClass"><xsl:if test="$useFixedWordPools='y'">fixedWordBox</xsl:if></xsl:variable>
		<xsl:variable name="collapsibleWordBoxClass"><xsl:if test="$useCollapsibleWordPools='y'">collapsibleWordBox collapsed</xsl:if></xsl:variable>

		<xsl:value-of select="normalize-space(concat('wordBox movable ', $className, ' ', $fixedWordBoxClass, ' ', $collapsibleWordBoxClass))"/>
	</xsl:template>

	<xsl:template name="wordBoxItemImageClasses">
		<xsl:param name="item"/>
		<xsl:call-template name="itemContentStylingClasses">
			<xsl:with-param name="itemElement" select="." />
		</xsl:call-template>
		<xsl:if test="count(.//image) + count(.//imageAudio) &gt; 0"> dragImageItem </xsl:if>
	</xsl:template>

	<xsl:template name="sentenceBuilderWordBoxClasses"  >
		<xsl:param name="useFixedWordPools" select="'n'"/>
		<xsl:variable name="fixedWordPoolClassItems">
			<xsl:if test="$useFixedWordPools='y'">fixedWordBox</xsl:if>
		</xsl:variable>
		<xsl:value-of select="normalize-space(concat('wordBox sentenceBuilderWordBox movable ', $fixedWordPoolClassItems))" />
	</xsl:template>

</xsl:stylesheet>
