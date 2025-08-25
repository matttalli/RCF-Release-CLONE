<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="itemTypeinGroup">

		<xsl:variable name="exampleClass">
			<xsl:choose>
				<xsl:when test="@example='y'">example</xsl:when>
				<xsl:when test="count(.//itemTypein[@example='y']) = count(.//itemTypein) and count(.//itemTypein)>0">example</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<span data-rcfid="{@id}" data-rcfinteraction="typeinGroup" class="typeinGroup itemTypeinGroup {$exampleClass} {@class}">
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
	 		<span class="markable dev-markable-container">
	 			<xsl:apply-templates/>
	 			<span class="mark">&#160;&#160;&#160;&#160;</span>
	 		</span>
	 	</span>

	</xsl:template>

	<xsl:template match="itemTypeinGroup//itemTypein">

		<xsl:variable name="longestItem"><xsl:apply-templates select="." mode="longestItem"/></xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or ancestor::typeinGroup/@example='y'">example</xsl:if></xsl:variable>

		<!-- output prefix -->
		<span class="prefix"><xsl:value-of select="prefix"/></span>

		<span>
			<xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>

			<input data-rcfid="{@id}" type="text"
				class="typeinGroup itemTypeInGroup {$exampleClass}"
				autocomplete="off"
				autocapitalize="off"
				spellcheck="false"
				autocorrect="off"
				maxlength="{string-length($longestItem)}"
				data-longestItem="{string-length($longestItem)}">

				<xsl:if test="@caseSensitive">
					<xsl:attribute name="data-casesensitive"><xsl:value-of select="@caseSensitive"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@example='y' or ancestor::itemTypeinGroup/@example='y'">
					<xsl:attribute name="readonly"/>
					<xsl:attribute name="value"><xsl:value-of select="normalize-space(acceptable/item[1]/text())"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			</input>
		</span>

		<!-- suffix -->
		<span class="suffix"><xsl:value-of select="suffix"/></span>
	</xsl:template>

	<!-- rcf_itembased_typeingroup -->
	<xsl:template match="itemTypeinGroup" mode="getItemBasedRcfClassName">
		rcfItemBasedTypeinGroup
	</xsl:template>

</xsl:stylesheet>
