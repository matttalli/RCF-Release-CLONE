<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="crossword">
		<div class="crosswordContainer" data-rcfinteraction="crossword" data-rcfid="{@id}"
			id="crossword_{@id}">
			<xsl:attribute name="data-wordsjson"><xsl:apply-templates select="words" mode="outputCrosswordJson"/></xsl:attribute>
			<xsl:if test="count(words/hiddenWord)>0">
				<xsl:attribute name="data-hiddenword"><xsl:value-of select="words/hiddenWord"/></xsl:attribute>
			</xsl:if>
				<!-- output JSON structure for the words -read in (then removed) by the rcf_crossword.js classes -->
			<div class="rcfCrossword"></div>
			<div class="crosswordClueContainer clearFix">
				<!-- populated by the crossword.js code -->
				<div class="clear"></div>
			</div>
			<!-- this div is removed and it's contents copied into the appropriate div above (across or down) when crossword has been generated -->
			<div class="hiddenClues">
				<div class="clues">
					<ul>
						<xsl:for-each select="words/word">
							<xsl:variable name="wordExampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
							<li class="clue {$wordExampleClass}" data-wordid="{@id}">
								<span class="crosswordClueNumber">
									<span class="crosswordClueNumbering"></span>
									<span class="crosswordClueNumberPunctuation"></span>
								</span>
								<xsl:text> </xsl:text><xsl:apply-templates select="clue"/>
							</li>
						</xsl:for-each>
					</ul>
				</div>
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

	<xsl:template match="words" mode="outputCrosswordJson">
		[
			<xsl:for-each select="word">{
				"id": "<xsl:value-of select="@id"/>",
				"firstLetterExample": "<xsl:value-of select="@firstLetterExample"/>",
				"isExample": "<xsl:value-of select="@example"/>",
				"word": "<xsl:value-of select="value"/>"
			}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		]
	</xsl:template>

	<!-- rcf_crossword -->
	<xsl:template match="crossword" mode="getRcfClassName">
		rcfCrossword
	</xsl:template>

</xsl:stylesheet>
