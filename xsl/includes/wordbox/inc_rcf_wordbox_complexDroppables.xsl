<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexDroppableBlock[@restrict='y']/complexDroppables/item" mode="wordBoxOutput">
		<!--
			only output complexDroppableBlock[restrict=y]//item in wordbox if it's used in the output at least once
		-->
		<xsl:variable name="complexDroppableId"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="itemUsedCount"><xsl:value-of select="count(ancestor::complexDroppableBlock//complexDroppable/item[@id=$complexDroppableId])"/></xsl:variable>
		<xsl:variable name="itemUsedAsAnExampleCount"><xsl:value-of select="count(ancestor::complexDroppableBlock//complexDroppable[@example='y']/item[@id=$complexDroppableId])"/></xsl:variable>
		<xsl:variable name="isExampleOnly"><xsl:if test="$itemUsedCount > 0 and ($itemUsedAsAnExampleCount = $itemUsedCount)">y</xsl:if></xsl:variable>

		<xsl:if test="not($isExampleOnly='y')">
			<xsl:apply-templates select="." mode="wordBoxComplexItemOutput"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="complexDroppableBlock[not(@restrict='y')]/complexDroppables/item" mode="wordBoxOutput">
		<!--
			always output items inside a standard (non-restricted) complexDroppableBlock
		-->
		<xsl:apply-templates select="." mode="wordBoxComplexItemOutput"/>
	</xsl:template>

	<xsl:template match="complexDroppables/item" mode="wordBoxComplexItemOutput">
		<xsl:variable name="complexDroppableId"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="correctItemCount">
			<xsl:choose>
				<xsl:when test="not(@restrictMaxShown)">
					<xsl:value-of select="count(ancestor::complexDroppableBlock//complexDroppable[not(@example='y')]/item[@id=$complexDroppableId])"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@restrictMaxShown"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="itemImageClasses">
			<xsl:call-template name="wordBoxItemImageClasses">
				<xsl:with-param name="item" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<li data-complexid="complex_{@id}"
			class="{normalize-space(concat('dragItem ui-draggable dev-droppable clickAndStickable complex ', $itemImageClasses))}"
			data-rcfid="{@id}"
			data-rcfTranslate=""
			aria-roledescription="[ interactions.droppable.dragItem.ariaRoleDescription ]"
			tabindex="0"
		>
			<xsl:if test="ancestor::complexDroppableBlock/@restrict='y'">
				<xsl:attribute name="data-restrictcount">
					<xsl:choose>
						<xsl:when test="$correctItemCount=0">1</xsl:when>
						<xsl:otherwise><xsl:value-of select="$correctItemCount"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute></xsl:if>
			<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

</xsl:stylesheet>
