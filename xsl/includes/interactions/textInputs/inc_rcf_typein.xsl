<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings" exclude-result-prefixes="str"
	xmlns:exsl="http://xml.apache.org/xalan"
	version="1.0">

	<!-- create the HTML for the 'typeIn' interactive -->
	<xsl:template match="typein">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="longestItem"><xsl:apply-templates select="." mode="longestItem" /></xsl:variable>

		<xsl:variable name="resizeType">
			<xsl:call-template name="calculateResizeType">
				<xsl:with-param name="resize" select="@resize" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ariaLabel">
			<xsl:call-template name="typeinAriaLabel">
				<xsl:with-param name="typeinElement" select="." />
				<xsl:with-param name="enumeration" select="count(preceding::typein[not(@example)]) + 1"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="maxSize">
			<xsl:choose>
				<xsl:when test="string-length($longestItem) > 30">30</xsl:when>
				<xsl:otherwise><xsl:value-of select="string-length($longestItem)" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="typeinNumber"><xsl:value-of select="count(preceding::typein) + 1" /></xsl:variable>

		<span
			data-rcfid="{@id}"
			data-rcfinteraction="markedTextInput"
			data-longestItem="{string-length($longestItem)}"
			class="{normalize-space(concat('typein', ' ', $exampleClass, ' ', @class))}"
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
					size="{$maxSize}"
					name="typein{$typeinNumber}"
					id="typein{$typeinNumber}"
					data-rcfTranslate=""
					aria-label="{$ariaLabel}"
				>
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
					<xsl:if test="preset"><xsl:attribute name="data-preset-answer"><xsl:value-of select="preset/text()"/></xsl:attribute></xsl:if>
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

	<xsl:template match="preset/text()"/>

	<!-- rcf_typein -->
	<xsl:template match="typein[not(ancestor::locating) and not(ancestor::typeinGroup)]" mode="getRcfClassName">
		rcfTypein
	</xsl:template>

</xsl:stylesheet>
