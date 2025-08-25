<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="inlineOrdering">
		<xsl:variable name="desktopOrientation">horizontal</xsl:variable>
		<xsl:variable name="mobileOrientation">mobile-horizontal</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="markableClass">
			<xsl:choose>
				<xsl:when test="not(@mark='item')">markable perList</xsl:when>
				<xsl:when test="@mark='item'">markable perItem</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dataMark">
 			<xsl:choose>
				<xsl:when test="not(@mark='item')">list</xsl:when>
				<xsl:when test="@mark='item'">item</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>
		<xsl:variable name="answers">[<xsl:apply-templates select="item" mode="generateOrderingAnswers"/>]</xsl:variable>
		<xsl:variable name="markTypeListMarkableClass"><xsl:if test="$dataMark='list'">dev-markable-container</xsl:if></xsl:variable>
		<xsl:variable name="childCount">answers<xsl:value-of select="count(child::item)"/></xsl:variable>
		<xsl:variable name="hasImageAnswers"><xsl:if test="(count(.//image) + count(.//imageAudio)) > 0">hasImageAnswers</xsl:if></xsl:variable>

		<span class="{normalize-space(concat('orderingContainer inline ', $markTypeListMarkableClass, ' ', $exampleClass, ' ', $childCount)) }"
			data-rcfinteraction="inlineOrdering"
			data-rcfid="{@id}"
			data-marktype="{$dataMark}"
			data-correct="{$answers}"
			aria-orientation="{$desktopOrientation}">

			<xsl:if test="@feedback">
				<xsl:attribute name="data-feedback"><xsl:value-of select="@feedback"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@capitalise='y'">
				<xsl:attribute name="data-capitalise"><xsl:value-of select="@capitalise"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'">
				<xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute>
			</xsl:if>

			<span class="{normalize-space(concat('inlineOrdering ordering ', $desktopOrientation, ' ', $mobileOrientation, ' ', $markableClass, ' ', $markTypeListMarkableClass, ' ', $exampleClass))}">
				<span class="{normalize-space(concat('inlineOrdering ordering ul rcfOrderingContainer ', $exampleClass))}">
					<xsl:if test="@capitalise='y'">
						<xsl:attribute name="data-capitalise">y</xsl:attribute>
					</xsl:if>
					<!-- now output each item -->
					<xsl:apply-templates/>
				</span>

				<xsl:if test="$dataMark='list'">
					<span class="mark">&#160;&#160;&#160;&#160;</span>
				</xsl:if>
			</span>
		</span>

	</xsl:template>

	<xsl:template match="inlineOrdering/suffix">
		<!-- these items are moved back to the end of the list after being randomized -->
		<!-- they are *not* allowed to be moved by the drag / drop functionality -->
		<span class="orderingItem suffix fixed" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::inlineOrdering/item)+1}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

    <xsl:template match="inlineOrdering/item">
		<xsl:variable name="fixedClass"><xsl:if test="@fixed='y'">fixed</xsl:if></xsl:variable>
		<xsl:variable name="markableContainerClass"><xsl:if test="../@mark='item'">dev-markable-container</xsl:if></xsl:variable>
		<xsl:variable name="imageAnswer"><xsl:if test="(count(.//image) + count(.//imageAudio)) > 0">imageAnswer</xsl:if></xsl:variable>

		<xsl:variable name="itemClass" select="normalize-space(concat('orderingItem', ' ', @class, ' ', $fixedClass, ' ',$markableContainerClass, ' ', $imageAnswer))"/>
		<xsl:variable name="dataMark">
			<xsl:choose>
				<xsl:when test="not(../@mark='item')">list</xsl:when>
				<xsl:when test="../@mark='item'">item</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<span data-rcfid="{@id}" class="{$itemClass}">
			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="data-ordervalue"><xsl:apply-templates mode="orderHash"/></xsl:attribute>
			<xsl:if test="count(@rank)>0">
				<xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@fixed='y'">
				<xsl:attribute name="data-fixed">y</xsl:attribute>
				<xsl:attribute name="data-fixedpos"><xsl:value-of select="position()"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@fixed='y') and not(@example='y') and not(../@example='y')">
				<xsl:attribute name="tabindex">0</xsl:attribute>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$dataMark='list'">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<span class="markable ordering">
						<xsl:apply-templates/>
						<xsl:if test="not(@fixed='y')">
							<span class="mark">&#160;&#160;&#160;&#160;</span>
						</xsl:if>
					</span>
				</xsl:otherwise>
			</xsl:choose>

		</span>

	</xsl:template>

	<xsl:template match="inlineOrdering/item" mode="generateOrderingAnswers">"<xsl:apply-templates mode="orderHash"/>"<xsl:if test="current()/following-sibling::item">,</xsl:if></xsl:template>

	<!-- rcf_inline_ordering -->
	<xsl:template match="inlineOrdering" mode="getRcfClassName">
		rcfInlineOrdering
	</xsl:template>

</xsl:stylesheet>
