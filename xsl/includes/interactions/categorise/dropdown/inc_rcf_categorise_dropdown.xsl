<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="categorise" mode="dropDown">
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

		<xsl:variable name="categoryOptions">
			<xsl:apply-templates mode="mobile-buildOptions"/>
		</xsl:variable>

		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="{normalize-space(concat('categorise dropDown ', $targetDisplay))}"
		>
			<xsl:element name="{$outputElementName}">
				<xsl:attribute name="class">categories dropDown <xsl:value-of select="$listClassName"/></xsl:attribute>

				<xsl:apply-templates select="category/item" mode="dropDown-output">
					<xsl:sort select="@rank" data-type="number" order="ascending"/>
				</xsl:apply-templates>
			</xsl:element>
		</div>
	</xsl:template>

	<xsl:template match="category/item" mode="dropDown-output">
		<xsl:variable name="correctValue"><xsl:value-of select="ancestor::category/@id"/></xsl:variable>
		<xsl:variable name="isExample"><xsl:value-of select="@example"/></xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>

		<li>
			<xsl:if test="@example='y'">
				<xsl:attribute name="class">example</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rank">
				<xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute>
			</xsl:if>

			<span class="categoryItem">
				<xsl:apply-templates/>
			</span>

			<span data-rcfid="{@id}" class="{normalize-space(concat('markable categoriseDropDown dev-markable-container ', $exampleClass))}">
				<select class="{normalize-space(concat('categoriseSelect ', $exampleClass))}">
					<xsl:for-each select="ancestor::categorise/category">
						<xsl:if test="not($isExample='y') or ($isExample='y' and $correctValue=@id)">
							<option value="{@id}" data-rcfid="{@id}">
								<xsl:if test="$isExample='y'">
									<xsl:attribute name="disabled"/>
									<xsl:if test="$correctValue=@id">
										<xsl:attribute name="selected"/>
									</xsl:if>
								</xsl:if>
								<xsl:value-of select="catName"/>
							</option>
						</xsl:if>
					</xsl:for-each>
				</select>
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</span>
		</li>
	</xsl:template>

</xsl:stylesheet>
