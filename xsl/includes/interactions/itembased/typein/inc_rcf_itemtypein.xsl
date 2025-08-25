<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="itemTypein">

		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>

		<!-- get longest answer from inc_rcf_typein-utils.xsl -->
		<xsl:variable name="longestItem"><xsl:apply-templates select="." mode="longestItem" /></xsl:variable>

		<xsl:variable name="resizeType">
			<xsl:call-template name="calculateResizeType">
				<xsl:with-param name="resize" select="@resize" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ariaLabel">
			<xsl:call-template name="typeinAriaLabel">
				<xsl:with-param name="typeinElement" select="." />
				<xsl:with-param name="enumeration"
					select="count(preceding::typein[not(@example)]) + 1"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<span
			data-rcfid="{@id}"
			data-rcfinteraction="markedTextInput"
			data-longestItem="{string-length($longestItem)}"
			class="typein itemTypein {$exampleClass} {@class}"
		>
			<xsl:if test="preset"><xsl:attribute name="data-preset-answer"><xsl:value-of select="preset/text()"/></xsl:attribute></xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<span class="prefix"><xsl:value-of select="prefix"/></span>
			<span class="markable dev-markable-container">
				<input type="text"
					autocomplete="off"
					autocapitalize="off"
					spellcheck="false"
					autocorrect="off"
					class="text {$exampleClass} markedTextInput"
					data-longestItem="{string-length($longestItem)}"
					data-longestString="{$longestItem}"
					data-resize="{$resizeType}"
					data-rcfTranslate=""
					aria-label="{$ariaLabel}"
				>
					<xsl:if test="preset"><xsl:attribute name="data-preset-answer"><xsl:value-of select="preset/text()"/></xsl:attribute></xsl:if>
					<xsl:if test="@restrict='y'">
						<xsl:attribute name="maxlength"><xsl:value-of select="string-length($longestItem)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@caseSensitive">
						<xsl:attribute name="data-casesensitive"><xsl:value-of select="@caseSensitive"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@ignorePunctuation">
						<xsl:attribute name="data-ignorepunctuation"><xsl:value-of select="@ignorePunctuation"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@example='y' or ../@example='y'"><xsl:attribute name="readonly"/><xsl:attribute name="value"><xsl:value-of select="normalize-space(acceptable/item[1]/text())"/></xsl:attribute></xsl:if>
				</input>
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</span>
			<span class="suffix"><xsl:value-of select="suffix"/></span>
			<xsl:if test="count(hint)>0">
				<span class="hintText" data-rcfTranslate="" aria-label="[ interactions.typein.hint ]">
					<xsl:choose>
						<xsl:when test="not(starts-with(hint, '('))"> (<span class="contentHintText"><xsl:value-of select="hint"/></span>)</xsl:when>
						<xsl:otherwise> <span class="contentHintText"><xsl:value-of select="hint"/></span></xsl:otherwise>
					</xsl:choose>
				</span>
			</xsl:if>
		</span>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="itemTypein/preset"/>

	<!-- rcf_itembased_typein -->
	<xsl:template match="itemTypein[not(ancestor::itemTypeinGroup)]" mode="getItemBasedRcfClassName">
		rcfItemBasedTypein
	</xsl:template>

</xsl:stylesheet>
