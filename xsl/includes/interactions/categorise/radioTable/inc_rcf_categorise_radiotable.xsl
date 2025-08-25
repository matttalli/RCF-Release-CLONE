<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="categorise" mode="radioTable">
		<xsl:param name="targetDisplay" select="'desktop'"/>

		<!-- should be the same for desktop/mobile -->
		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="categorise {$targetDisplay} radioTable"
		>
			<table class="radioTable" cellspacing="0">
				<thead>
					<tr class="tableHeadRow">
						<th class="leftCell topLeftTH">&#160;</th>
						<xsl:for-each select="category">
							<th class="catNameTH" data-catid='{@id}'><span><xsl:apply-templates select="catName"/></span></th>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="category/item">
						<xsl:sort select="@rank" data-type="number" order="ascending"/>

						<xsl:variable name="genID" />
						<xsl:variable name="radioName">rad_<xsl:value-of select="$genID"/>_<xsl:value-of select="$targetDisplay"/></xsl:variable>
						<xsl:variable name="correctValue"><xsl:value-of select="ancestor::category/@id"/></xsl:variable>
						<xsl:variable name="isExample"><xsl:value-of select="@example"/></xsl:variable>
						<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
						<xsl:variable name="itemID"><xsl:value-of select="@id"/></xsl:variable>

						<tr class="{normalize-space(concat('tableAnswerRow ', $exampleClass))}" data-rcfid="{$itemID}" >
							<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>

							<td class="leftCell"><xsl:apply-templates/></td>

							<xsl:for-each select="ancestor::categorise/category">
								<xsl:variable name="isCorrect"><xsl:if test="count(.//item[@id=$itemID])>0">y</xsl:if></xsl:variable>
								<td class="dev-markable-container">
									<span class="radioTableItem markable">
										<input id="{ancestor::categorise/@id}_{$itemID}_{@id}_{$targetDisplay}"
											name="{ancestor::categorise/@id}_{$itemID}_{$targetDisplay}"
											data-rcfid="{$itemID}"
											type="radio"
											value="{@id}"
										>
											<xsl:if test="$exampleClass!=''">
												<xsl:attribute name="class"><xsl:value-of select="$exampleClass"/></xsl:attribute>
											</xsl:if>
											<xsl:if test="$isExample='y' and $isCorrect='y'"><xsl:attribute name="data-correct">y</xsl:attribute><xsl:attribute name="checked"/></xsl:if>
										</input>
										<span class="mark">&#160;&#160;&#160;&#160;</span>
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
