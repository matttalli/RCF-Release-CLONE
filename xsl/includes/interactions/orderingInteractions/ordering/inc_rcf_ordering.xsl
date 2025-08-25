<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="ordering">
		<xsl:variable name="instructionId" select="concat(@id, '-instructions')"/>
		<xsl:variable name="instructions">
			<xsl:choose>
				<xsl:when test="item//*[@audio]">
					<xsl:text>[ interactions.ordering.instructions.imageAudio ]</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>[ interactions.ordering.instructions.regular ]</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
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
		<xsl:variable name="interactionContentClasses">
			<xsl:call-template name="interactionContentStylingClasses">
				<xsl:with-param name="interactionElement" select="." />
			</xsl:call-template>
		</xsl:variable>

		<div class="ordering-wrapper">
			<div class="visually-hidden" id="{$instructionId}" data-rcfTranslate=""><xsl:value-of select="$instructions"/></div>

			<div class="{normalize-space(concat('orderingContainer ', $markTypeListMarkableClass, ' ', $exampleClass, ' ', $childCount, ' ', $interactionContentClasses)) }"
				data-rcfinteraction="ordering"
				data-rcfid="{@id}"
				data-marktype="{$dataMark}"
				data-correct="{$answers}"
				>

				<xsl:if test="@feedback">
					<xsl:attribute name="data-feedback"><xsl:value-of select="@feedback"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@capitalise='y'">
					<xsl:attribute name="data-capitalise"><xsl:value-of select="@capitalise"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$authoring='Y'">
					<xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute>
				</xsl:if>

				<span class="{normalize-space(concat('ordering ', $desktopOrientation, ' ', $mobileOrientation, ' ', $markableClass, ' ', $markTypeListMarkableClass, ' ', $exampleClass))}">
					<ul class="{normalize-space(concat('ordering rcfOrderingContainer ', $exampleClass))}" role="listbox" aria-orientation="{$desktopOrientation}" data-rcfTranslate="" aria-roledescription="[ interactions.ordering.screenReader.orderingListLabel ]" aria-label="[ interactions.ordering.screenReader.orderingListLabel ]" aria-describedby="{@id}-instructions">
						<xsl:if test="@capitalise='y'">
							<xsl:attribute name="data-capitalise">y</xsl:attribute>
						</xsl:if>
						<!-- now output each item -->
						<xsl:apply-templates/>
					</ul>
					<xsl:if test="$dataMark='list'">
						<span class="mark">&#160;&#160;&#160;&#160;</span>
					</xsl:if>
				</span>
			</div>
		</div>

	</xsl:template>

	<xsl:template match="ordering/suffix">
		<!-- these items are moved back to the end of the list after being randomized -->
		<!-- they are *not* allowed to be moved by the drag / drop functionality -->
		<li class="suffix fixed orderingItem" role="option" aria-disabled="true" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::ordering/item)+1}">
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="ordering/item">
		<xsl:variable name="fixedClass"><xsl:if test="@fixed='y'">fixed</xsl:if></xsl:variable>
		<xsl:variable name="markableContainerClass"><xsl:if test="../@mark='item'">dev-markable-container</xsl:if></xsl:variable>
		<xsl:variable name="itemContentClasses">
			<xsl:call-template name="itemContentStylingClasses">
				<xsl:with-param name="itemElement" select="." />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="itemClass" select="normalize-space(concat('orderingItem', ' ', @class, ' ', $fixedClass, ' ',$markableContainerClass, ' ', $itemContentClasses))"/>
		<xsl:variable name="dataMark">
			<xsl:choose>
				<xsl:when test="not(../@mark='item')">list</xsl:when>
				<xsl:when test="../@mark='item'">item</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<li data-rcfid="{@id}" class="{$itemClass}" role="option">
			<xsl:attribute name="aria-label">
				<xsl:choose>
					<xsl:when test=".//@a11yTitle and string(.//@a11yTitle)">
						<xsl:value-of select="(.//@a11yTitle)[1]"/>
					</xsl:when>
					<xsl:when test=".//@alt and string(.//@alt)">
						<xsl:value-of select="(.//@alt)[1]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
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
			<xsl:if test="not(@fixed='y') and count(preceding-sibling::item[not(@fixed='y')]) = 0">
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

		</li>

	</xsl:template>

	<xsl:template match="ordering/item" mode="generateOrderingAnswers">"<xsl:apply-templates mode="orderHash"/>"<xsl:if test="current()/following-sibling::item">,</xsl:if></xsl:template>

	<!-- rcf_ordering -->
	<xsl:template match="ordering" mode="getRcfClassName">
		rcfOrdering
	</xsl:template>

</xsl:stylesheet>
