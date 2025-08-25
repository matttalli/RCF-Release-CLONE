<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="fixedWordSearch">
		<xsl:variable name="interactive">
			<xsl:choose>
				<xsl:when test="not(@interactive='n')">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="numRows"><xsl:value-of select="count(wordSearchGrid/row)"/></xsl:variable>
		<xsl:variable name="numValidRows"><xsl:value-of select="count(wordSearchGrid/row[string-length(.)=$numRows])"/></xsl:variable>
		<xsl:variable name="longestWord">
			<xsl:for-each select="words/word">
				<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="string-length(.)"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="longestColumn">
			<xsl:for-each select="wordSearchGrid/row">
				<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="string-length(.)"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="numberOfValidRows">
			<xsl:value-of select="count(wordSearchGrid//row[string-length(.)=$longestColumn])"/>
		</xsl:variable>

		<xsl:variable name="wordSearchValidationMessage">
			<xsl:choose>
				<xsl:when test="$numRows!=$numberOfValidRows">The number of rows and number of columns in the xml do not match</xsl:when>
				<xsl:when test="$longestWord &gt; $longestColumn and $longestWord &gt; $numRows">
					The following word(s) are too big for the grid :
					<xsl:for-each select="words/word[string-length(.) &gt; $longestColumn]">
						"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">, </xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>valid</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isValidFixedWordSearch">
			<xsl:if test="$wordSearchValidationMessage='valid'">y</xsl:if>
		</xsl:variable>

		<!-- container for the grid -->
		<div class="wordSearchContainer fixed" data-rcfinteraction="wordSearch" data-rcfid="{@id}"
				data-interactive="{$interactive}"
				data-isFixed="y"
				data-isValid="{$isValidFixedWordSearch}"
				data-usediagonal="y"
				data-usevertical="y"
				data-usereverse="y"
				data-longestword="{$longestWord}"
				data-gridRows="{count(wordSearchGrid/row)}"
				data-gridCols="{string-length(wordSearchGrid/row[1])}"
			>
			<xsl:attribute name="data-words">{ "fixed": "y", "words": [<xsl:for-each select="words/word"><xsl:sort select="string-length(.)" data-type="number" order="descending"/>{"word":"<xsl:value-of select="."/>", "length": <xsl:value-of select="string-length(.)"/><xsl:if test="@example">, "example": "<xsl:value-of select="@example"/>"</xsl:if>,"startRow": <xsl:value-of select="@startRow"/>, "startCol": <xsl:value-of select="@startCol"/>, "direction": "<xsl:value-of select="@direction"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}</xsl:attribute>
			<xsl:attribute name="data-draggable">
				<xsl:choose>
					<xsl:when test="ancestor::activity/@desktopDraggable='n'">n</xsl:when>
					<xsl:when test="@clickStick='y'">n</xsl:when>
					<xsl:otherwise>y</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:choose>
				<xsl:when test="$isValidFixedWordSearch='y'">
					<xsl:apply-templates />
					<!-- if interactive, then output the container for the 'word list' -->
					<xsl:if test="$interactive='y'">
						<div class="wordsContainer">
							<div class="rcfWordSearchGridChosenWords">
								<ul class="wordSearchWords"></ul>
							</div>
						</div>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<div class="errorMessage"><xsl:value-of select="$wordSearchValidationMessage"/></div>
				</xsl:otherwise>

			</xsl:choose>
		</div>

	</xsl:template>

	<xsl:template match="wordSearchGrid">
		<div class="wordSearchGridContainer fixed">
			<div class="rcfWordSearchGrid">
				<table class="rcfTableGrid" cellspacing="0" cellpadding="0">
					<tbody>
						<xsl:apply-templates/>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="wordSearchGrid/row">
		<tr>
			<xsl:call-template name="outputColumns">
				<xsl:with-param name="text" select="text()"/>
				<xsl:with-param name="gridPrefix" select="ancestor::fixedWordSearch/@id"/>
				<xsl:with-param name="rowNumber" select="count(preceding-sibling::row)"/>
				<xsl:with-param name="colNumber" select="'0'"/>
			</xsl:call-template>
		</tr>
	</xsl:template>

	<xsl:template match="fixedWordSearch/words/word"/>

	<xsl:template name="outputColumns">
		<xsl:param name="text"/>
		<xsl:param name="gridPrefix"/>
		<xsl:param name="rowNumber"/>
		<xsl:param name="colNumber"/>

		<xsl:variable name="cellId" select="concat('r', $rowNumber, 'c', $colNumber)"/>

		<td id="{$gridPrefix}_{$cellId}" data-cellid="{$cellId}" class="rcfWSCell">
			<xsl:value-of select="substring($text, 1, 1)"/>
		</td>

		<xsl:if test="string-length($text) > 1">
			<xsl:call-template name="outputColumns">
				<xsl:with-param name="text" select="substring($text, 2, string-length($text)-1)"/>
				<xsl:with-param name="gridPrefix" select="$gridPrefix"/>
				<xsl:with-param name="rowNumber" select="$rowNumber"/>
				<xsl:with-param name="colNumber" select="$colNumber + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- rcf_wordsearch -->
	<xsl:template match="fixedWordSearch" mode="getRcfClassName">
		rcfWordSearch
	</xsl:template>

</xsl:stylesheet>
