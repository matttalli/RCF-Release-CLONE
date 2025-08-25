<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="categorise" mode="radioList">
		<xsl:param name="targetDisplay" select="'mobile'" />

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

		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="categorise {$targetDisplay} radioList"
		>
			<xsl:element name="{$outputElementName}">
				<xsl:attribute name="class">categories radioList <xsl:value-of select="$listClassName"/></xsl:attribute>

				<xsl:for-each select="category/item">
					<xsl:sort select="@rank" data-type="number" order="ascending"/>

					<xsl:variable name="itemID"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="isExample"><xsl:value-of select="@example"/></xsl:variable>
					<xsl:variable name="exampleClass"><xsl:if test="$isExample='y'">example</xsl:if></xsl:variable>

					<li data-rcfid="{@id}" class="{normalize-space(concat('radioListCategoryItem dev-markable-container ', $exampleClass))}">
						<xsl:if test="not($isExample='y') and not(ancestor::categorise/@marked='n') and not(ancestor::activity/@marked='n')">
							<xsl:attribute name="data-requires-answers">y</xsl:attribute>
						</xsl:if>
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>

						<span><xsl:apply-templates/></span>
						<ul>
							<xsl:for-each select="ancestor::categorise/category">
								<li>
									<span class="markable categoriseRadioList">
										<input id="item_{$targetDisplay}_{$itemID}_{position()}"
											name="{$itemID}_{$targetDisplay}"
											data-rcfid="{$itemID}"
											type="radio"
											value="{@id}">
											<xsl:if test="$isExample='y' and count(.//item[@id=$itemID])>0"><xsl:attribute name="checked"/><xsl:attribute name="data-correct">y</xsl:attribute></xsl:if>
										</input>
										<label for="item_{$targetDisplay}_{$itemID}_{position()}">
											<xsl:apply-templates select="catName"/>
										</label>
										<span class="mark">&#160;&#160;&#160;&#160;</span>
									</span>
								</li>
							</xsl:for-each>
						</ul>
					</li>
				</xsl:for-each>
			</xsl:element>
		</div>
	</xsl:template>

</xsl:stylesheet>
