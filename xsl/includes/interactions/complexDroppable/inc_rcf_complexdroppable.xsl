<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- check for a complex droppable block -->
	<xsl:template match="complexDroppableBlock">
		<!-- <xsl:comment>$fixedWordPools = <xsl:value-of select="$fixedWordPools"/></xsl:comment> -->
		<xsl:if test="$wordBoxPosition='default'">
			<!-- check if wordbox is the first in the activity if multiple complexDroppableBlocks are used ... *AND* we are not inside a splitBlock-->
			<xsl:if test="generate-id()=generate-id(ancestor::activity//complexDroppableBlock[1])">
				<xsl:if test="count(following::droppable)=0 and count(preceding::droppable)=0 and not(ancestor::splitBlock)">

					<xsl:call-template name="standardWordBox">
						<xsl:with-param name="activity" select="ancestor::activity"/>
						<xsl:with-param name="className" select="'complexDroppable'"/>
						<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
						<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- create the HTML for a 'complexDroppable' interactive -->
	<xsl:template match="complexDroppable">
		<xsl:variable name="imageAnswerClass">
			<xsl:variable name="itemId"><xsl:value-of select="item[1]/@id" /></xsl:variable>
			<xsl:variable name="droppable"
				select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]" />
			<xsl:call-template name="itemContentStylingClasses">
				<xsl:with-param name="itemElement" select="$droppable" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="populatedClass"><xsl:if test="@example='y'">populated</xsl:if></xsl:variable>
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<xsl:variable name="firstCorrectID"><xsl:value-of select="item[1]/@id" /></xsl:variable>
		<xsl:variable name="containsImages">
			<xsl:for-each select="item">
				<xsl:variable name="itemId"><xsl:value-of select="@id" /></xsl:variable>
				<xsl:if test="count(ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]//image) + count(ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]//imageAudio) &gt; 0">y</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="imagesClass"><xsl:if test="contains($containsImages, 'y')">complexDroppableImage</xsl:if></xsl:variable>
		<xsl:variable name="dropTargetImagesClass"><xsl:if test="contains($containsImages, 'y')">complexDragImageTarget</xsl:if></xsl:variable>

		<xsl:variable name="titleText">
			<xsl:choose>
				<xsl:when test="@example='y'">[ interactions.droppable.exampleDropTarget.title ]</xsl:when>
				<xsl:otherwise>[ interactions.droppable.dropTarget.title ] <xsl:value-of select="count(preceding::complexDroppable[not(@example)]) + 1" />, [ interactions.droppable.dropTarget.empty ]</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<span data-rcfid="{@id}" data-rcfinteraction="complexDroppable"
			class="{normalize-space(concat('complexDroppable clickAndStickable rcfDroppable ', $exampleClass, ' ', $imagesClass, ' ', $imageAnswerClass))}"
		>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			<xsl:if test="prefix">
				<span class="prefix"><xsl:value-of select="prefix"/></span>
			</xsl:if>

			<span class="markable dev-markable-container">
				<span
					class="{normalize-space(concat('dev-droppable complexDroppable dragTarget movable ', $populatedClass, ' ', $exampleClass, ' ', $capitaliseClass, ' ', $dropTargetImagesClass))}"
					data-rcfTranslate="" title="{$titleText}" role="region">
					<xsl:if test="@example='y'">
						<xsl:if test="ancestor::complexDroppableBlock/complexDroppables/item[@id=$firstCorrectID]/@audio">
							<xsl:attribute name="data-audiolink"><xsl:value-of select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$firstCorrectID]/@audio"/></xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@capitalise='y'"><xsl:attribute name="data-capitalise">y</xsl:attribute></xsl:if>
					<xsl:if test="@example='y'"><xsl:apply-templates select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$firstCorrectID]"/></xsl:if>
					<xsl:if test="not(@example='y')">
						<xsl:attribute name="tabindex">0</xsl:attribute>
					</xsl:if>
				</span>
				<span class="mark" aria-hidden="true">&#160;&#160;&#160;&#160;</span>
			</span>
			<xsl:if test="suffix">
				<span class="suffix"><xsl:value-of select="suffix"/></span>
			</xsl:if>
		</span>
	</xsl:template>

	<!-- rcf_droppables -->
	<xsl:template match="complexDroppable" mode="getRcfClassName">
		rcfDroppable
	</xsl:template>

</xsl:stylesheet>
