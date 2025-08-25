<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- create the HTML for a 'droppable' interactive -->
	<xsl:template match="droppable">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="imageAnswerClass">
			<xsl:call-template name="itemContentStylingClasses">
				<xsl:with-param name="itemElement" select="." />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="droppableImageClass"><xsl:if test="count(.//image) + count(.//imageAudio) &gt; 0">droppableImage</xsl:if></xsl:variable>

		<span data-rcfid="{@id}" data-rcfinteraction="droppable"
			class="{normalize-space(concat('rcfDroppable dev-markable-container clickAndStickable markable droppable ', @class, ' ', $droppableImageClass, ' ', $exampleClass))}"
		>
			<xsl:if test="@correctFeedbackAudio"><xsl:attribute name="data-correctfeedbackaudio"><xsl:value-of select="@correctFeedbackAudio"/></xsl:attribute></xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			<xsl:variable name="imageClass"><xsl:if test="count(.//image) + count(.//imageAudio) &gt; 0">dragImageTarget</xsl:if></xsl:variable>
			<xsl:variable name="populatedClass"><xsl:if test="@example='y'">populated</xsl:if></xsl:variable>
			<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>

			<xsl:variable name="titleText">
				<xsl:choose>
					<xsl:when test="@example='y'">[ interactions.droppable.exampleDropTarget.title ]</xsl:when>
					<xsl:otherwise>[ interactions.droppable.dropTarget.title ] <xsl:value-of select="count(preceding::complexDroppable[not(@example)]) + 1" />, [ interactions.droppable.dropTarget.empty ]</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<span
				class="{normalize-space(concat('dev-droppable droppable dragTarget movable ',$imageClass,' ',$imageAnswerClass,' ',$populatedClass,' ',$exampleClass,' ',$capitaliseClass))}"
				data-rcfTranslate="" title="{$titleText}" role="region">
				<xsl:if test="@example='y'"><xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio" /></xsl:attribute></xsl:if></xsl:if>
				<xsl:if test="@capitalise='y'"><xsl:attribute name="data-capitalise">y</xsl:attribute></xsl:if>
				<xsl:if test="not(@example='y')">
					<xsl:attribute name="tabindex">0</xsl:attribute>
				</xsl:if>
				<xsl:if test="@example='y'"><xsl:apply-templates/></xsl:if>


			</span>
			<span class="mark" aria-hidden="true">&#160;&#160;&#160;&#160;</span>
		</span>
	</xsl:template>

	<!-- rcf_droppables -->
	<xsl:template match="droppable" mode="getRcfClassName">
		rcfDroppable
	</xsl:template>

</xsl:stylesheet>
