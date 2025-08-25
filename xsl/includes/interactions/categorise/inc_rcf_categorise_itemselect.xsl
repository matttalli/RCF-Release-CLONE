<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="categorise" mode="itemSelectList">
		<xsl:param name="targetDisplay" select="'mobile'"/>

		<!-- determine list-type element to use -->
		<xsl:variable name="outputElementName">
			<xsl:choose>
				<xsl:when test="@list='plain' or not(@list)">ul</xsl:when>
				<xsl:otherwise>ol</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- determine class name for the list element -->
		<xsl:variable name="listClassName">
			<xsl:choose>
				<xsl:when test="@list='plain' or not(@list)">plain</xsl:when>
				<xsl:when test="@list='numbered'">numbered</xsl:when>
				<xsl:when test="@list='alpha'">alpha</xsl:when>
				<xsl:when test="@list='upper-alpha'">upper-alpha</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<!-- output the categorise interaction ! -->
		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="categorise {$targetDisplay} itemSelectList"
		>
			<!-- outputs a 'ul', 'ol' depending on @list attribute value on <categorise> -->
			<xsl:element name="{$outputElementName}">
				<xsl:attribute name="class">categories itemSelectList vertical <xsl:value-of select="$listClassName"/></xsl:attribute>

				<xsl:for-each select="category/item">
					<xsl:sort select="@rank" data-type="number" order="ascending"/>
					<xsl:variable name="categoryItemID"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="isExample"><xsl:value-of select="@example"/></xsl:variable>
					<xsl:variable name="exampleClass"><xsl:if test="$isExample='y'">example</xsl:if></xsl:variable>

					<li data-rcfid="{$categoryItemID}" class="{normalize-space(concat('itemSelectListItem dev-markable-container ', $exampleClass))}">
						<xsl:if test="not($isExample='y') and not(ancestor::categorise/@example='y') and not(ancestor::categorise/@marked='n') and not(ancestor::activity/@marked='n')">
							<xsl:attribute name="data-requires-answers">y</xsl:attribute>
						</xsl:if>
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<p><xsl:apply-templates/></p>
						<span class="categoriseItemSelect">
							<xsl:for-each select="ancestor::categorise/category">
								<xsl:variable name="checkedClass"><xsl:if test="$isExample='y' and count(.//item[@id=$categoryItemID])>0">selected</xsl:if></xsl:variable>
								<span class="{normalize-space(concat('markable selectable category ', $checkedClass))}" data-rcfid="{@id}">
									<xsl:apply-templates select="catName"/>
									<span class="mark">&#160;&#160;&#160;&#160;</span>
								</span>
							</xsl:for-each>
						</span>
					</li>
				</xsl:for-each>
			</xsl:element>
		</div>

	</xsl:template>

</xsl:stylesheet>
