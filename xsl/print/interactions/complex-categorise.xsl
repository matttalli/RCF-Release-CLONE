<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- complex categorise for print should always be output as a checkbox table -->
	<xsl:template match="complexCategorise[@isInteraction='y']">
		<div class="{@printClass}" data-rcfid="{@id}">
			<table class="rcfPrint-checkbox-table" cellspacing="0">
				<tbody>
					<tr>
						<th class="rcfPrint-checkbox-table-top-left-header">
							<!-- top / left hand cell is always empty -->
						</th>
						<xsl:for-each select="categories/category">
							<th class="rcf-category-table-header">
								<span><xsl:apply-templates select="catName"/></span>
							</th>
						</xsl:for-each>
					</tr>
					<!-- output the items - order of which is determined by activity/@sortItemsAlphabetically and activity/@randomizeItems -->
					<xsl:apply-templates select="items"/>
				</tbody>

			</table>
		</div>
	</xsl:template>

	<xsl:template match="activity[@sortItemsAlphabetically='y']//complexCategorise/items">
		<!-- always output all items (including examples) in alphabetical order -->
		<xsl:apply-templates mode="outputTableRow"/>
	</xsl:template>

	<xsl:template match="activity[not(@sortItemsAlphabetically='y')]//complexCategorise/items">
		<!-- always output examples first, then the items in the order they appear in the XML -->
		<xsl:for-each select="item">
			<xsl:if test="count(ancestor::complexCategorise/categories/category/item[@id=current()/@id and @example='y'])>0">
				<xsl:apply-templates select="." mode="outputTableRow"/>
			</xsl:if>
		</xsl:for-each>

		<!-- now the non-examples -->
		<xsl:for-each select="item">
			<xsl:if test="count(ancestor::complexCategorise/categories/category/item[@id=current()/@id and @example='y'])=0">
				<xsl:apply-templates select="." mode="outputTableRow"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="complexCategorise/items/item" mode="outputTableRow">
		<xsl:variable name="itemID"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="numberOfExamplesWithThisId"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID and @example='y'])"/></xsl:variable>
		<xsl:variable name="numberOfUsesOfThisId"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID])"/></xsl:variable>

		<xsl:variable name="isExampleAndUnusedElsewhere">
			<xsl:choose>
				<xsl:when test="$numberOfExamplesWithThisId>0 and $numberOfExamplesWithThisId = $numberOfUsesOfThisId">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="itemExampleClass"><xsl:if test="$isExampleAndUnusedElsewhere='y'">example</xsl:if></xsl:variable>

		<tr data-rcfid="{$itemID}">
			<td class="{normalize-space(concat('rcf-category-item-name ', $itemExampleClass))}">
				<xsl:apply-templates/>
			</td>

			<xsl:for-each select="ancestor::complexCategorise/categories/category">
				<xsl:variable name="isExample"><xsl:value-of select="item[@id=$itemID]/@example"/></xsl:variable>
				<xsl:variable name="exampleClass"><xsl:if test="$isExample='y' or $isExampleAndUnusedElsewhere='y'">example</xsl:if></xsl:variable>

				<td class="rcf-category-item-choice">
					<span>
						<xsl:if test="not($isExampleAndUnusedElsewhere='y') or ($isExampleAndUnusedElsewhere='y' and count(item[@id=$itemID])=1)">
							<!-- `return false` here so that print preview html checkboxes in browser are not 'clickable' -->
							<input class="{$exampleClass}" type="checkbox" onclick="return false">
								<xsl:if test="$isExample='y'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
								<xsl:if test="$isExample='y' or $isExampleAndUnusedElsewhere='y'">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
							</input>
						</xsl:if>
					</span>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<!-- we want to ignore / not output imageAudio and audio elements in the items/item elements -->
	<xsl:template match="complexCategorise/items/item//imageAudio">
		<!-- image audio ignored here -->
	</xsl:template>

	<xsl:template match="complexCategorise/items/item//image">
		<!-- image ignored here -->
	</xsl:template>

	<xsl:template match="complexCategorise/items/item//audio">
		<!-- audio element ignored here -->
	</xsl:template>

	<!-- answer key output -->
	<xsl:template match="complexCategorise" mode="outputAnswerKeyValueForInteraction">
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer</xsl:variable>

		<span class="{normalize-space($className)}" data-rcfid="{@id}">
			<xsl:for-each select="categories/category">
				<b><xsl:apply-templates select="catName" mode="outputAnswerKeyValueForInteraction"/></b>:

				<xsl:for-each select="item[not(@example='y')]">
					<xsl:value-of select="normalize-space(ancestor::complexCategorise/items/item[@id=current()/@id]/text())"/>
					<xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				<br/>
			</xsl:for-each>
		</span>
	</xsl:template>

</xsl:stylesheet>
