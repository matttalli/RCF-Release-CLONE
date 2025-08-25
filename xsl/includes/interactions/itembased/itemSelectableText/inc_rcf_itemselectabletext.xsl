<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="itemSelectableText">
        <xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
        <xsl:variable name="devMarkableContainerClass"><xsl:if test="@mark='list'">dev-markable-container</xsl:if></xsl:variable>

        <div data-rcfid="{@id}" data-rcfinteraction="interactiveText" class="interactiveText {@class} type_selectable itemSelectableText {$exampleClass} {$devMarkableContainerClass}" data-interactivetexttype="selectable" data-marktype="{@mark}">
			<xsl:if test="@restrict='y'">
				<xsl:attribute name="data-rcfrestrict"><xsl:value-of select="count(.//*[@correct='y' and not(@example='y') ])"/></xsl:attribute>
			</xsl:if>

			<div class="itMain itemSelectableTextMain">
				<xsl:apply-templates/>
				<xsl:if test="@mark='list'">
					<span class="selectableMarkContainer"><span class="mark">&#160;&#160;&#160;&#160;</span></span>
				</xsl:if>
			</div>
		</div>

	</xsl:template>

	<!-- rcf_itembased_selectabletext -->
	<xsl:template match="itemSelectableText" mode="getItemBasedRcfClassName">
		rcfItemBasedSelectableText
	</xsl:template>

</xsl:stylesheet>
