<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="categorise | complexCategorise">

		<xsl:if test="@desktopDisplay='radioTable'">
			<xsl:apply-templates select="." mode="radioTable">
				<xsl:with-param name="targetDisplay" select="'desktop'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@desktopDisplay='draggable' or @desktopDisplay=''">
			<xsl:apply-templates select="." mode="hybrid">
				<xsl:with-param name="targetDisplay" select="'desktop'"/>
				<xsl:with-param name="useMobileDragDrop" select="$mobileDragDrop"/>
				<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@desktopDisplay='checkboxTable'">
			<xsl:apply-templates select="." mode="checkboxTable">
				<xsl:with-param name="targetDisplay" select="'desktop'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@desktopDisplay='itemSelectList'">
			<xsl:apply-templates select="." mode="itemSelectList">
				<xsl:with-param name="targetDisplay" select="'desktop'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='checkboxTable'">
			<xsl:apply-templates select="." mode="checkboxTable">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='checkboxList'">
			<xsl:apply-templates select="." mode="checkboxList">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='radioTable'">
			<xsl:apply-templates select="." mode="radioTable">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='radioList'">
			<xsl:apply-templates select="." mode="radioList">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='itemSelectList'">
			<xsl:apply-templates select="." mode="itemSelectList">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='dropDown'">
			<xsl:apply-templates select="." mode="dropDown">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="@mobileDisplay='touchable' or @mobileDisplay=''">
			<xsl:apply-templates select="." mode="hybrid">
				<xsl:with-param name="targetDisplay" select="'mobile'"/>
				<xsl:with-param name="useMobileDragDrop" select="$mobileDragDrop"/>
				<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
			</xsl:apply-templates>
		</xsl:if>

	</xsl:template>

	<xsl:template match="categorise | complexCategorise" mode="getRcfMobileClassName">
		<xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		rcfCategorise<xsl:value-of select="concat(translate(substring(@mobileDisplay, 1,1), $vLower, $vUpper), substring(@mobileDisplay, 2))"/>
	</xsl:template>

	<xsl:template match="categorise | complexCategorise" mode="getRcfDesktopClassName">
		<xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		rcfCategorise<xsl:value-of select="concat(translate(substring(@desktopDisplay, 1,1), $vLower, $vUpper), substring(@desktopDisplay, 2))"/>
	</xsl:template>


</xsl:stylesheet>
