<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="distractors" mode="wordBoxOutput">
		<xsl:variable name="complexClass">
			<xsl:if test="count(ancestor::activity//complexDroppables/item)>0">complex</xsl:if>
		</xsl:variable>
		<xsl:variable name="restrictedComplex">
			<xsl:if test="count(ancestor::activity//complexDroppableBlock[@restrict='y'])>0">y</xsl:if>
		</xsl:variable>

		<xsl:for-each select="item">
			<xsl:variable name="itemImageClasses">
				<xsl:call-template name="wordBoxItemImageClasses">
					<xsl:with-param name="item" select="."/>
				</xsl:call-template>
			</xsl:variable>

			<li
				class="{normalize-space(concat('dragItem ui-draggable distractor dev-droppable clickAndStickable ', $complexClass, ' ', $itemImageClasses))}"
				data-rcfid="{@id}"
				data-rcfTranslate=""
				aria-roledescription="[ interactions.droppable.dragItem.ariaRoleDescription ]"
				tabindex="0"
			>
				<xsl:if test="$complexClass and $restrictedComplex='y'"><xsl:attribute name="data-restrictcount">1</xsl:attribute></xsl:if>
				<xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute></xsl:if>
				<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
				<xsl:apply-templates/>
			</li>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
