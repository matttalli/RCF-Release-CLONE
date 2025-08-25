<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexCategorise" mode="checkboxList">
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

		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="categorise complexCategorise checkboxList {$targetDisplay} {$restrictedClass}"
		>
			<xsl:element name="{$outputElementName}">
				<xsl:attribute name="class">categories checkboxList <xsl:value-of select="$listClassName"/></xsl:attribute>

				<xsl:for-each select="items/item">
					<xsl:sort select="@rank" data-type="number" order="ascending"/>
					<xsl:variable name="itemID"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="catItemID"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="numberOfInstancesOfThisItem"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID])"/></xsl:variable>
					<xsl:variable name="numberOfExampleInstancesOfThisItem"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$itemID and @example='y'])"/></xsl:variable>
					<xsl:variable name="distractorClassValue"><xsl:if test="$numberOfInstancesOfThisItem=0 or $numberOfInstancesOfThisItem=$numberOfExampleInstancesOfThisItem">distractor</xsl:if></xsl:variable>

					<xsl:variable name="restrictCount">
						<xsl:choose>
							<xsl:when test="ancestor::complexCategorise/@restrict='y'"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$catItemID and not(@example='y')])"/></xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<li class="checkboxListCategoryItem {$distractorClassValue}" data-rcfid="{$itemID}">
						<xsl:if test="not($distractorClassValue='distractor') and not(ancestor::complexCategorise/@example='y') and not(ancestor::complexCategorise/@marked='n') and not(ancestor::activity/@marked='n')">
							<xsl:attribute name="data-requires-answers">y</xsl:attribute>
						</xsl:if>

						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<xsl:if test="ancestor::complexCategorise/@restrict='y'"><xsl:attribute name="data-restrictcount"><xsl:value-of select="$restrictCount"/></xsl:attribute></xsl:if>
						<p><xsl:apply-templates/></p>
						<ul>
							<xsl:for-each select="ancestor::complexCategorise/categories/category">
								<xsl:variable name="isCorrect"><xsl:if test="count(item[@id=$catItemID])>0">y</xsl:if></xsl:variable>
								<xsl:variable name="isExampleItem"><xsl:value-of select="item[@id=$catItemID]/@example"/></xsl:variable>
								<xsl:variable name="exampleClass"><xsl:if test="$isExampleItem='y'">example</xsl:if></xsl:variable>
								<xsl:variable name="useID">
									<xsl:value-of select="ancestor::complexCategorise/@id"/>_<xsl:value-of select="$catItemID"/>_<xsl:value-of select="position()"/>
								</xsl:variable>
								<li>
									<span class="{normalize-space(concat('markable complexCategoriseCheckBoxList dev-markable-container ', $exampleClass))}">
										<input id="checkboxListCat_{$useID}"
											class="{normalize-space(concat('complexCategoriseCheckBox ', $exampleClass))}"
											type="checkbox"
											data-rcfid="{$itemID}"
											value="{@id}">
											<xsl:if test="$isExampleItem='y'"><xsl:attribute name="disabled"/><xsl:attribute name="data-correct">y</xsl:attribute><xsl:attribute name="checked"/></xsl:if>
										</input>
										<label for="checkboxListCat_{$useID}">
											<xsl:apply-templates select="catName"/>
										</label>
										<span id="mark_{$useID}" class="mark">&#160;&#160;&#160;&#160;</span>
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
