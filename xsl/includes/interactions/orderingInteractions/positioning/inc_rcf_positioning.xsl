<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- create the HTML for a positioning interactive -->
	<xsl:template match="positioning">
		<xsl:variable name="desktopOrientation">
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
				<xsl:otherwise>vertical</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="mobileOrientation">
			<xsl:choose>
				<xsl:when test="@mobileDisplay='h'">mobile-horizontal</xsl:when>
				<xsl:when test="@mobileDisplay='v'">mobile-vertical</xsl:when>
				<xsl:otherwise>mobile-<xsl:value-of select="$desktopOrientation"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="markableClass">markable perList</xsl:variable>

		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>
		<xsl:variable name="answers">[<xsl:apply-templates select="item" mode="generatePositioningAnswers"/>]</xsl:variable>
		<xsl:variable name="childCount">answers<xsl:value-of select="count(child::item)"/></xsl:variable>
		<xsl:variable name="interactionContentClasses">
			<xsl:call-template name="interactionContentStylingClasses">
				<xsl:with-param name="interactionElement" select="." />
			</xsl:call-template>
		</xsl:variable>

		<div class="orderingContainer {$exampleClass} dev-markable-container {$childCount} {$interactionContentClasses}"
			data-rcfid="{@id}"
			data-rcfinteraction="positioning"
			data-marktype="list"
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

			<span class="ordering positionable {$desktopOrientation} {$mobileOrientation} {$markableClass} dev-markable-container {$exampleClass}">
				<ul class="{normalize-space(concat('ordering positionable rcfOrderingContainer ', $exampleClass))}">
					<xsl:if test="@capitalise='y'">
						<xsl:attribute name="data-capitalise">y</xsl:attribute>
					</xsl:if>
					<!-- now output each item -->
					<xsl:choose>
						<xsl:when test="not(@example='y')">
							<xsl:apply-templates select="item[not(@positionable='y')]"/>
							<xsl:apply-templates select="item[@positionable='y']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</span>
		</div>

	</xsl:template>

	<xsl:template match="positioning/item">
		<xsl:variable name="dataMark">list</xsl:variable>
		<xsl:variable name="sortIndex">
			<xsl:choose>
				<xsl:when test="@positionable='y' and not(@rank)"><xsl:value-of select="count(preceding-sibling::item[@positionable='y']) + 1000 "/></xsl:when>
				<xsl:when test="@positionable='y' and not(@rank='')"><xsl:value-of select="@rank + 1000"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="300+count(preceding-sibling::item[not(@positionable) or @positionable='n'])"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="itemContentClasses">
			<xsl:call-template name="itemContentStylingClasses">
				<xsl:with-param name="itemElement" select="." />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="fixedClass">
			<xsl:if test="not(@positionable='y')">fixed</xsl:if>
		</xsl:variable>

		<li data-rcfid="{@id}" data-sortindex="{$sortIndex}" class="{normalize-space(concat('orderingItem ', @class, ' ', $itemContentClasses, ' ', $fixedClass))}">
			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@positionable='y' and not(@rank='')"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
			<xsl:attribute name="data-ordervalue"><xsl:apply-templates mode="orderHash"/></xsl:attribute>
			<xsl:if test="not(@positionable='y')">
				<xsl:attribute name="data-fixed">y</xsl:attribute>
			</xsl:if>
			<xsl:if test="@positionable='y' and not(@example='y') and not(../@example='y')">
				<xsl:attribute name="tabindex">0</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</li>

	</xsl:template>

	<xsl:template match="positioning/item" mode="generatePositioningAnswers">"<xsl:apply-templates mode="orderHash"/>"<xsl:if test="current()/following-sibling::item">,</xsl:if></xsl:template>

	<!-- rcf_positioning -->
	<xsl:template match="positioning" mode="getRcfClassName">
		rcfPositioning
	</xsl:template>

</xsl:stylesheet>
