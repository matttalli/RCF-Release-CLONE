<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- create the HTML for a 'itemSelectable' checkbox item -->
	<xsl:template match="itemCheckbox[@displayType='itemSelect']">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="not(@mark)">list</xsl:when>
				<xsl:otherwise><xsl:value-of select="@mark"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="orientation">
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
				<xsl:otherwise>vertical</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="markableContainerClass"><xsl:if test="$markType='list'">dev-markable-container</xsl:if></xsl:variable>
		<xsl:variable name="answerCountClass"><xsl:value-of select="concat(' answer', count(item))"/></xsl:variable>
		<xsl:variable name="hasImageAnswersClass"><xsl:if test="count(.//image) + count(.//imageAudio) > 0">hasImageAnswers</xsl:if></xsl:variable>

		<span id="{@id}" data-rcfid="{@id}" data-rcfinteraction="checkboxItemSelect"
			class="{normalize-space(concat('checkboxItemSelect itemCheckboxItemSelect ', $orientation, ' ', $exampleClass, ' ', @class, ' ', @type, ' ', $markableContainerClass, ' ', $answerCountClass, ' ', $hasImageAnswersClass))}"
			data-markType="{$markType}"
		>
			<xsl:if test="not(@example='y') and not(@marked='n') and count(item[@correct='y']) &gt; 0 and not(ancestor::activity/@marked='n')">
				<xsl:attribute name="data-requires-answers">y</xsl:attribute>
			</xsl:if>
			<xsl:if test="@restrict='y'">
				<xsl:attribute name="data-rcfrestrict"><xsl:value-of select="count(item[@correct='y' and not(@example='y')])"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="$markType='list'">
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</xsl:if>
		</span>
	</xsl:template>

	<!-- create the HTML for a checkbox item selectable interactive item -->
	<xsl:template match="itemCheckbox[@displayType='itemSelect']/item">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="not(ancestor::itemCheckbox/@mark)">list</xsl:when>
				<xsl:otherwise><xsl:value-of select="ancestor::itemCheckbox/@mark"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or ancestor::itemCheckbox[@example='y']">example <xsl:if test="@correct='y'"> selected</xsl:if></xsl:if></xsl:variable>
		<xsl:variable name="markableContainerClass"><xsl:if test="$markType='item'">dev-markable-container</xsl:if></xsl:variable>
		<xsl:variable name="imageAnswerClass"><xsl:if test="count(.//image) + count(.//imageAudio) > 0">imageAnswer</xsl:if></xsl:variable>

		<span data-rcfid="{@id}"
			class="{normalize-space(concat('markable selectable checkbox dev-list-item ', $exampleClass, ' ', @class, ' ', $markableContainerClass, ' ', $imageAnswerClass))}" role="checkbox">
			<xsl:choose>
				<xsl:when test="(@example='y' or ancestor::itemCheckbox[@example='y']) and @correct='y'">
					<xsl:attribute name="aria-checked">true</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="aria-checked">false</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(@example='y' or ancestor::itemCheckbox[@example='y'])"><xsl:attribute name="tabindex">0</xsl:attribute></xsl:if>
			<xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute></xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:if test="@example='y' and @correct='y'"><xsl:attribute name="data-correct">y</xsl:attribute></xsl:if>
			<xsl:if test="@correctFeedbackAudio"><xsl:attribute name="data-correctfeedbackaudio"><xsl:value-of select="@correctFeedbackAudio"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="not($markType='list')">
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</xsl:if>
		</span>
	</xsl:template>

	<!-- rcf_checkbox_item_selectable -->
	<xsl:template match="itemCheckbox[@displayType='itemSelect']" mode="getItemBasedRcfClassName">
		rcfItemCheckboxItemSelect
	</xsl:template>

</xsl:stylesheet>
