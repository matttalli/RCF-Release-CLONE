<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexCategorise" mode="checkboxTable">
		<xsl:param name="targetDisplay" select="'desktop'"/>

		<xsl:variable name="restrictedClass"><xsl:if test="@restrict='y'">restricted</xsl:if></xsl:variable>

		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="categorise complexCategorise checkboxTable {$targetDisplay} {$restrictedClass}"
		>
			<table class="checkboxTable" cellspacing="0">
				<thead>
					<tr class="tableHeadRow">
						<th class="leftCell topLeftTH">&#160;</th>
						<xsl:for-each select="categories/category">
							<th class="catNameTH categoryCol" data-rcfid="{@id}"><span><xsl:apply-templates select="catName"/></span></th>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="items/item">
						<xsl:sort select="@rank" data-type="number" order="ascending"/>
						<xsl:variable name="itemID"><xsl:value-of select="@id"/></xsl:variable>
						<xsl:variable name="distractorClassValue"><xsl:if test="count(ancestor::complexCategorise/categories/category/item[@id=$itemID])=0">distractor</xsl:if></xsl:variable>

						<xsl:variable name="numberOfExamplesWithThisId"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID and @example='y'])"/></xsl:variable>

						<xsl:variable name="numberOfUsesOfThisId"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID])"/></xsl:variable>

						<xsl:variable name="isExampleAndUnusedElsewhere">
							<xsl:choose>
								<xsl:when test="$numberOfExamplesWithThisId>0 and $numberOfExamplesWithThisId = $numberOfUsesOfThisId">y</xsl:when>
								<xsl:otherwise>n</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="restrictCount">
							<xsl:choose>
								<xsl:when test="ancestor::complexCategorise/@restrict='y'"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID and not(@example='y')])"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<tr class="tableAnswerRow {$distractorClassValue}" data-rcfid="{@id}">
							<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
							<xsl:if test="ancestor::complexCategorise/@restrict='y'"><xsl:attribute name="data-restrictcount"><xsl:value-of select="$restrictCount"/></xsl:attribute></xsl:if>
							<td class="leftCell">
								<xsl:apply-templates/>
							</td>
							<xsl:for-each select="ancestor::complexCategorise/categories/category">
								<xsl:variable name="isExample"><xsl:value-of select="item[@id=$itemID]/@example"/></xsl:variable>
								<xsl:variable name="exampleClass"><xsl:if test="$isExample='y' or $isExampleAndUnusedElsewhere='y'">example</xsl:if></xsl:variable>
								<td>
									<span class="markable checkboxTable">
										<input class="complexCategoriseCheckBox {$exampleClass}"
											type="checkbox"
											data-rcfid="{$itemID}"
											data-catid="{@id}">
											<xsl:if test="$isExample='y'">
												<xsl:attribute name="checked"/>
											</xsl:if>
											<xsl:if test="$isExample='y' or $isExampleAndUnusedElsewhere='y'">
												<xsl:attribute name="disabled"/>
											</xsl:if>
										</input>
										<span class="markContext">
											<span class="mark">&#160;&#160;&#160;&#160;</span>
										</span>
									</span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>

	</xsl:template>
</xsl:stylesheet>
