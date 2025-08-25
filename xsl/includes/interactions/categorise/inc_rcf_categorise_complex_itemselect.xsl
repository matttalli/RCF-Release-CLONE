<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexCategorise" mode="itemSelectList">
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

		<xsl:variable name="restrictedClass"><xsl:if test="@restrict='y'">restricted</xsl:if></xsl:variable>

		<!-- output the categorise interaction -->
		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="categorise {$targetDisplay} itemSelectList complexCategorise {$restrictedClass}"
		>
			<!-- outputs a 'ul', 'ol' depending on @list attribute value on <categorise> -->
			<xsl:element name="{$outputElementName}">
				<xsl:attribute name="class">categories itemSelectList vertical <xsl:value-of select="$listClassName"/></xsl:attribute>

				<xsl:for-each select="items/item">
					<xsl:sort select="@rank" data-type="number" order="ascending"/>
					<xsl:variable name="categoryItemID"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="restrictCount">
						<xsl:choose>
							<xsl:when test="ancestor::complexCategorise/@restrict='y'"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$categoryItemID and not(@example='y')])"/></xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="numberOfInstances"><xsl:value-of select="count(ancestor::complexCategorise/categories//item[@id=$categoryItemID])"/></xsl:variable>
					<xsl:variable name="numberOfExampleInstances"><xsl:value-of select="count(ancestor::complexCategorise/categories//item[@example='y' and @id=$categoryItemID ])"/></xsl:variable>
					<xsl:variable name="exampleClass"><xsl:if test="$numberOfInstances = $numberOfExampleInstances and $numberOfExampleInstances>0">example</xsl:if></xsl:variable>


					<li data-rcfid="{$categoryItemID}" class="{normalize-space(concat('itemSelectListItem ', $exampleClass))}">
						<xsl:if test="not($exampleClass='example') and $numberOfInstances &gt; 0 and not(ancestor::complexCategorise/@example='y') and not(ancestor::complexCategorise/@marked='n') and not(ancestor::activity/@marked='n')">
							<xsl:attribute name="data-requires-answers">y</xsl:attribute>
						</xsl:if>
						<xsl:if test="ancestor::complexCategorise/@restrict='y'"><xsl:attribute name="data-restrictcount"><xsl:value-of select="$restrictCount"/></xsl:attribute></xsl:if>
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<p><xsl:apply-templates/></p>

						<span class="categoriseItemSelect">
							<xsl:for-each select="ancestor::complexCategorise/categories/category">
								<xsl:variable name="isExample"><xsl:if test="item[@id=$categoryItemID]/@example='y'">y</xsl:if></xsl:variable>
								<xsl:variable name="itemExampleClass"><xsl:if test="$isExample='y'">example disabled</xsl:if></xsl:variable>
								<xsl:variable name="checkedClass"><xsl:if test="$isExample='y' and count(.//item[@id=$categoryItemID])>0">selected</xsl:if></xsl:variable>
								<span class="{normalize-space(concat('markable selectable category dev-markable-container ', $checkedClass, ' ', $itemExampleClass))}" data-rcfid="{@id}">
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
