<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="fixedCrossword">
		<xsl:variable name="hiddenWord">
			<xsl:for-each select="hiddenWord/letter"><xsl:value-of select="text()"/></xsl:for-each>
		</xsl:variable>

		<xsl:variable name="numberOfAcrossWords" select="count(words/word[@direction='across'])"/>
		<xsl:variable name="numberOfDownWords" select="count(words/word[@direction='down'])"/>
		<xsl:variable name="hasCluesClass"><xsl:if test="@hideClues='y'">hiddenClues</xsl:if></xsl:variable>

		<div class="{normalize-space(concat('crosswordContainer fixedCrosswordContainer ', $hasCluesClass))}"
			data-rcfinteraction="fixedCrossword"
			data-rcfid="{@id}" >
			<xsl:attribute name="data-wordsjson"><xsl:apply-templates select="words" mode="outputFixedCrosswordJson"/></xsl:attribute>

			<xsl:if test="normalize-space($hiddenWord)!=''">
				<xsl:attribute name="data-hiddenword"><xsl:value-of select="$hiddenWord"/></xsl:attribute>
				<xsl:attribute name="data-hiddenwordsjson"><xsl:apply-templates select="hiddenWord" mode="outputHiddenWordsJson"/></xsl:attribute>
			</xsl:if>

			<div class="rcfCrossword">
				<xsl:apply-templates mode="outputFixedCrossword"/>
			</div>

			<div class="crosswordClueContainer clearFix">
				<xsl:if test="$numberOfAcrossWords > 0">
					<xsl:call-template name="outputCrosswordClueList">
						<xsl:with-param name="direction" select="'across'"/>
						<xsl:with-param name="directionLabel" select="'Across'"/>
						<xsl:with-param name="directionClass" select="'across'"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$numberOfDownWords > 0">
					<xsl:call-template name="outputCrosswordClueList">
						<xsl:with-param name="direction" select="'down'"/>
						<xsl:with-param name="directionLabel" select="'Down'"/>
						<xsl:with-param name="directionClass" select="'down'"/>
					</xsl:call-template>
				</xsl:if>

				<div class="clear"></div>
			</div>
			<div class="crosswordPopup">
				<div class="crosswordClueLabel"></div>
				<div class="crosswordInputContainer">
					<input id="crosswordMobileTypein" type="text"
						autocomplete="off"
						autocapitalize="off"
						spellcheck="false"
						autocorrect="off"
						class="crosswordMobileTypein text"
					></input>
				</div>
				<div class="crosswordButtonsContainer">
					<span class="textControls">
						<a href="javascript:;" class="okButton singleButton">
							<span data-rcfTranslate="">[ components.button.ok ]</span>
						</a>
						<a href="javascript:;" class="cancelButton singleButton" >
							<span data-rcfTranslate="">[ components.button.cancel ]</span>
						</a>
					</span>
				</div>
			</div>
		</div>

	</xsl:template>

	<xsl:template match="fixedCrossword/gridSize" mode="outputFixedCrossword">
		<table class="crossword">
			<xsl:call-template name="outputFixedCrosswordRow">
				<xsl:with-param name="rowNumber" select="'1'"/>
			</xsl:call-template>
		</table>
	</xsl:template>

	<xsl:template match="words" mode="outputFixedCrosswordJson">
		[
			<xsl:for-each select="word" >
				<xsl:sort select="@startRow" data-type="number"/>
				<xsl:sort select="@startCol" data-type="number"/>
			{
				"id": "<xsl:value-of select="@id"/>",
				"clueNumber": <xsl:value-of select="@clueNumber"/>,
				"startRow": <xsl:value-of select="@startRow"/>,
				"startCol": <xsl:value-of select="@startCol"/>,
				"direction": "<xsl:value-of select="@direction"/>",
				"firstLetterExample": "<xsl:value-of select="@firstLetterExample"/>",
				"isExample": "<xsl:value-of select="@example"/>",
				"word": "<xsl:value-of select="value"/>"
			}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		]
	</xsl:template>

	<xsl:template match="hiddenWord" mode="outputHiddenWordsJson">
		[
			<xsl:for-each select="letter">
				<xsl:variable name="cellId" select="concat('r', @row, 'c', @col)"/>
			{
				"cellId": "<xsl:value-of select="$cellId"/>",
				"value": "<xsl:value-of select="text()"/>"
			}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		]
	</xsl:template>

	<xsl:template name="outputFixedCrosswordRow">
		<xsl:param name="rowNumber" />
		<tr data-row="{$rowNumber}">
			<xsl:call-template name="outputFixedCrosswordCol">
				<xsl:with-param name="rowNumber" select="$rowNumber"/>
				<xsl:with-param name="colNumber" select="'1'"/>
			</xsl:call-template>
		</tr>
		<xsl:if test="$rowNumber &lt; @rows">
			<xsl:call-template name="outputFixedCrosswordRow">
				<xsl:with-param name="rowNumber" select="$rowNumber + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="outputFixedCrosswordCol">
		<xsl:param name="rowNumber" />
		<xsl:param name="colNumber" />

		<xsl:variable name="cellId" select="concat('r', $rowNumber, 'c', $colNumber)"/>

		<td id="{ancestor::fixedCrossword/@id}_{$cellId}" class="" data-col="{$colNumber}" data-cellid="{$cellId}">

		</td>

		<xsl:if test="$colNumber &lt; @cols" >
			<xsl:call-template name="outputFixedCrosswordCol">
				<xsl:with-param name="rowNumber" select="$rowNumber"/>
				<xsl:with-param name="colNumber" select="$colNumber + 1"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	<xsl:template name="outputCrosswordClueList">
		<xsl:param name="direction"/>
		<xsl:param name="directionLabel"/>
		<xsl:param name="directionClass"/>

		<xsl:variable name="directionTranslationKey" select="concat('interactions.crossword.', $direction)"/>

		<div class="{$directionClass}">
			<h3 data-rcfTranslate="">
				[ <xsl:value-of select="$directionTranslationKey"/> ]
			</h3>
			<ul>
				<xsl:for-each select="words/word[@direction=$direction]">
					<xsl:sort select="@startRow" data-type="number"/>
					<xsl:sort select="@startCol" data-type="number"/>
					<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>

					<li
						class="{normalize-space(concat('clue ', $exampleClass))}"
						data-wordid="{@id}"
					>
						<span class="crosswordClueNumber">
							<span class="crosswordClueNumbering">
								<xsl:value-of select="@clueNumber"/>
							</span>
						</span>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="clue"/>
					</li>
				</xsl:for-each>
			</ul>
		</div>

	</xsl:template>

	<xsl:template match="fixedCrossword/words/word/value/text()" mode="outputFixedCrossword"/>

	<!--
		RCF-9374 - currently this was only ignoring 'a string' when it was the first text child of <clue>
			eg:	<clue>a string</clue>

		so by making it ignore *all* text() nodes inside a <clue>, we can get it to ignore everything in here :

			eg: <clue>a <b>clue <i>and</i> embeded ones too</b>.</clue>
	-->
	<xsl:template match="fixedCrossword/words/word/clue//text()" mode="outputFixedCrossword"/>
	<xsl:template match="fixedCrossword/hiddenWord/letter/text()" mode="outputFixedCrossword"/>

	<!-- rcf_fixed_crossword -->
	<xsl:template match="fixedCrossword" mode="getRcfClassName">
		rcfFixedCrossword
	</xsl:template>

</xsl:stylesheet>
