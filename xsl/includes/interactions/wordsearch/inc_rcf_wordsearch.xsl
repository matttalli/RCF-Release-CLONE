<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!--
		output the wordsearch grid html container

		this contains the following data attributes :

		data-usediagonal (y/n)	: output diagonal words in grid (default N)
		data-usevertical (y/n)  : output vertical words in grid (default Y)
		data-usereverse (y/n) 	: output reverse words in grid (default N)
		data-gridsize (int) 	: grid size specified in xml (default - length of longest word +2)
		data-interactive (y/n) 	: is grid interactive (click / touch / drag selections) (default N)
		data-wordlist (string[]): array of words to place into grid (removed once html generated in javascript)
		data-longestword (int) 	: length of longest word

	-->
	<xsl:template match="wordSearch">
		<xsl:variable name="interactive">
			<xsl:choose>
				<xsl:when test="not(@interactive='n')">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="useVertical">
			<xsl:choose>
				<xsl:when test="not(@useVertical='n')">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="wordSearchContainer" data-rcfinteraction="wordSearch" data-rcfid="{@id}"
				data-interactive="{$interactive}"
				data-usediagonal="{@useDiagonal}"
				data-usevertical="{$useVertical}"
				data-usereverse="{@useReverse}"
				data-gridsize="{@gridSize}"
		>
			<xsl:attribute name="data-draggable">
				<xsl:choose>
					<xsl:when test="ancestor::activity/@desktopDraggable='n'">n</xsl:when>
					<xsl:when test="@clickStick='y'">n</xsl:when>
					<xsl:otherwise>y</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="data-words">{ "words": [<xsl:for-each select="words/word"><xsl:sort select="string-length(.)" data-type="number" order="descending"/>{"word":"<xsl:value-of select="."/>", "length": <xsl:value-of select="string-length(.)"/><xsl:if test="@example">, "example": "<xsl:value-of select="@example"/>"</xsl:if>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}</xsl:attribute>
			<xsl:attribute name="data-longestword"><xsl:for-each select="words/word"><xsl:sort select="string-length(.)" data-type="number" order="descending"/><xsl:if test="position()=1"><xsl:value-of select="string-length(.)+2"/></xsl:if></xsl:for-each></xsl:attribute>
			<!-- container for the grid -->
 			<div class="wordSearchGridContainer">
			</div>
			<!-- if interactive, then output the container for the 'word list' -->
			<xsl:if test="$interactive='y'">
				<div class="wordsContainer">
					<div class="rcfWordSearchGridChosenWords">
						<ul class="wordSearchWords"></ul>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- rcf_wordsearch -->
	<xsl:template match="wordSearch" mode="getRcfClassName">
		rcfWordSearch
	</xsl:template>

</xsl:stylesheet>
