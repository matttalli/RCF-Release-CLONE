<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- create the HTML for a complexOrdering element - not too disimilar to a standard 'ordering' -->
	<xsl:template match="complexOrdering">
		<xsl:variable name="desktopOrientation">
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
				<xsl:otherwise>horizontal</xsl:otherwise>
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
				<xsl:when test="not(@mark='item')">markable perList dev-markable-container</xsl:when>
				<xsl:when test="@mark='item'">perItem</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dataMark">list</xsl:variable>
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>
		<xsl:variable name="answers">[[<xsl:for-each select="items/item">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:for-each select="alternativeOrderings/order">[<xsl:for-each select="item">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]</xsl:variable>
		<xsl:variable name="childCount">answers<xsl:value-of select="count(child::items/item)"/></xsl:variable>
		<xsl:variable name="interactionContentClasses">
			<xsl:call-template name="interactionContentStylingClasses">
				<xsl:with-param name="interactionElement" select="." />
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('orderingContainer ', $exampleClass, ' complex ', $childCount, ' ', $interactionContentClasses))}"
			data-rcfinteraction="complexOrdering"
			data-rcfid="{@id}"
			data-marktype="list"
			data-correct="{$answers}"
			aria-orientation="{$desktopOrientation}">

			<xsl:if test="@feedback">
				<xsl:attribute name="data-feedback"><xsl:value-of select="@feedback"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@capitalise='y'">
				<xsl:attribute name="data-capitalise"><xsl:value-of select="@capitalise"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			<span class="complexOrdering ordering {$desktopOrientation} {$mobileOrientation} {$markableClass} {$exampleClass}">

				<ul data-rcfid="{@id}"
					class="{normalize-space(concat('complexOrdering ordering rcfOrderingContainer', ' ', $exampleClass))}">
					<xsl:if test="@capitalise='y'"><xsl:attribute name="data-capitalise">y</xsl:attribute></xsl:if>

	 				<!-- now output each item -->
					<xsl:for-each select="items/item">
						<xsl:variable name="fixedClass"><xsl:if test="@fixed='y'">fixed</xsl:if></xsl:variable>
						<xsl:variable name="userClass"><xsl:if test="@class"><xsl:value-of select="@class"/></xsl:if></xsl:variable>
						<xsl:variable name="itemContentClasses">
							<xsl:call-template name="itemContentStylingClasses">
								<xsl:with-param name="itemElement" select="." />
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="itemClass" select="concat('orderingItem', ' ', $userClass, ' ', $fixedClass, ' ', $itemContentClasses)"/>

						<li data-rcfid="{@id}"
							data-complexitemid="{@id}"
							data-ordervalue="{@id}"
							class="{normalize-space($itemClass)}">
							<xsl:if test="@audio">
								<xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="count(@rank)>0">
								<xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="@fixed='y'">
								<xsl:attribute name="data-fixed">y</xsl:attribute>
								<xsl:attribute name="data-fixedpos"><xsl:value-of select="position()"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="not(@fixed='y') and not(@example='y') and not(ancestor::complexOrdering[@example='y'])">
								<xsl:attribute name="tabindex">0</xsl:attribute>
							</xsl:if>

							<xsl:apply-templates/>

						</li>
					</xsl:for-each>

					<xsl:if test="count(items/suffix)>0">
						<xsl:apply-templates select="items/suffix"/>
					</xsl:if>

				</ul>
				<span class="mark">&#160;&#160;&#160;&#160;</span>

			</span>
		</div>
		<!-- <div class="clear"/> -->

	</xsl:template>

	<xsl:template match="complexOrdering/items/suffix">
		<!-- these items are moved back to the end of the list after being randomized -->
		<!-- they are *not* allowed to be moved by the drag / drop functionality -->
		<li class="suffix fixed orderingItem" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::complexOrdering/items/item)+1}">
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<!-- rcf_complex_ordering -->
	<xsl:template match="complexOrdering" mode="getRcfClassName">
		rcfComplexOrdering
	</xsl:template>

</xsl:stylesheet>
