<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:include href="ordering/inc_rcf_ordering.xsl"/>
	<xsl:include href="positioning/inc_rcf_positioning.xsl"/>
	<xsl:include href="complexOrdering/inc_rcf_complexordering.xsl"/>
	<xsl:include href="inlineOrdering/inc_rcf_inlineordering.xsl"/>

	<!-- utilities used by the ordering interactions xsl -->
<!--
	<xsl:template name="outputMobileControls">
		<xsl:param name="hideMobileControls" select="'n'"/>
		<xsl:param name="rippleClass"/>

		<xsl:if test="$hideMobileControls='n'">
			<span class="orderingControls">
				<a href="javascript:;" class="dev-mobileOrderingButton singleButton {$rippleClass} orderingUpControl"><span></span></a>
				<a href="javascript:;" class="dev-mobileOrderingButton singleButton {$rippleClass} orderingDownControl"><span></span></a>
			</span>
		</xsl:if>

	</xsl:template>
-->
	<!-- templates to generate text 'hash' for sort / correct sort-order comparisons -->
	<xsl:template match="*" mode="orderHash"><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="orderHash"/><xsl:apply-templates mode="orderHash"/></xsl:template>

	<!-- templates to generate text 'hash' for sort / correct sort-order comparisons -->
	<xsl:template match="@*" mode="orderHash">.<xsl:value-of select="name()"/>.<xsl:value-of select="normalize-space(.)"/></xsl:template>

	<!-- templates to generate text 'hash' for sort / correct sort-order comparisons -->
	<xsl:template match="text()" mode="orderHash"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="normalize-space(.)"/></xsl:call-template></xsl:template>

</xsl:stylesheet>
