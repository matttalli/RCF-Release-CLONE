<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		vertical crossword xsl

		xml should be in the format....

            <verticalCrossword id="vc1">
            	<word id="word_1" letter="S" example="y">FISH</word>
            	<word id="word_2" letter="U">
            		FRUIT
            	</word>
            	<word id="word_3" letter="N">
            		CHICKIN
            	</word>
            	<word id="word_4" letter="D">
            		SALAD
            	</word>
            	<word id="word_5" letter="I">
            		FISH
            	</word>
            	<word id="word_6" letter="A">
            		CATS
            	</word>
                <word id="word_7" letter="L">
                    LLAMA
                </word>
            </verticalCrossword>


	-->

	<xsl:template match="verticalCrossword">
		<xsl:comment>vertical-crossword</xsl:comment>
		<xsl:variable name="verticalCrosswordId"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="useExamplesForCrossingWord" select="@exampleCrossingWord"/>
		<xsl:variable name="hasCluesClass"><xsl:if test="clues">hasClues</xsl:if></xsl:variable>

		<!-- get the 'longestPosition' - the word with the 'furthest away' letter in the hidden word -->
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="longestPosition">
			<xsl:for-each select="word">
				<xsl:sort select="string-length(substring-before(normalize-space(text()), @letter))" order="descending"/>
				<xsl:if test="position()=1"><xsl:value-of select="string-length(substring-before(normalize-space(text()), @letter))+1"/></xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="firstLetterExample" select="@firstLetterExample"/>

		<!-- start outputting the table -->
		<div class="{normalize-space(concat('verticalCrosswordContainer ', @class, ' ', $hasCluesClass, ' ', $exampleClass))}"
			data-rcfinteraction="verticalCrossword"
			data-rcfid="{@id}"
			data-firstLetterExample="{$firstLetterExample}"
		>
			<table class="verticalCrossword">
				<xsl:for-each select="word">
					<xsl:variable name="numBlanks"><xsl:value-of select="$longestPosition - string-length(substring-before(normalize-space(text()), @letter))"/></xsl:variable>
					<xsl:variable name="exampleWordClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
					<tr tabindex="0" class="{normalize-space(concat('vcLine dev-markable-container ', $exampleWordClass, ' ', @class))}" data-rcf-wordid="{@id}">
						<xsl:if test="$hasCluesClass!=''">
							<xsl:variable name="clueId"><xsl:value-of select="../clues/clue[@wordId=current()/@id]/@id"/></xsl:variable>
							<xsl:if test="$clueId!=''">
								<xsl:attribute name="aria-describedby"><xsl:value-of select="concat('clue-', $verticalCrosswordId, '-', @id)"/></xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:call-template name="outputSpacing">
							<xsl:with-param name="numBlanks" select="$numBlanks"/>
						</xsl:call-template>
						<!-- output 'number' column -->
						<td class="vcNumber">
							<span class="vcNumbering">
								<xsl:value-of select="position()"/>
							</span>
							<span class="vcNumberingPunctuation">.</span>
						</td>
						<!-- now output the typeins for the words -->
						<xsl:variable name="isExample"><xsl:if test="ancestor::verticalCrossword/@example='y' or @example='y'">y</xsl:if></xsl:variable>
						<xsl:call-template name="outputTypeins">
							<xsl:with-param name="answerValue" select="normalize-space(text())"/>
							<xsl:with-param name="isExample" select="$isExample"/>
							<xsl:with-param name="exampleCrossingWord" select="$useExamplesForCrossingWord"/>
							<xsl:with-param name="useLetter" select="@letter"/>
							<xsl:with-param name="firstLetterExample" select="$firstLetterExample"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>

			</table>
			<!-- now output the crossing word clue -->
			<xsl:apply-templates select="crossingWordClue"/>
			<!-- now output the clues if any ... -->
			<xsl:apply-templates select="clues"/>
		</div>
	</xsl:template>

	<xsl:template match="verticalCrossword/clues">
		<div class="crosswordClueContainer">
			<ul>
				<xsl:for-each select="../word">
					<xsl:apply-templates select="../clues/clue[@wordId=current()/@id]"/>
					<!-- <xsl:apply-templates/> -->
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="verticalCrossword/clues/clue">
		<xsl:variable name="verticalCrosswordId"><xsl:value-of select="ancestor::verticalCrossword/@id"/></xsl:variable>
		<xsl:variable name="wordId"><xsl:value-of select="@wordId"/></xsl:variable>
		<xsl:variable name="currentWord" select="ancestor::verticalCrossword/word[@id=$wordId]"/>
		<xsl:variable name="precedingWordsCount" select="count($currentWord/preceding-sibling::word) + 1"/>
		<xsl:variable name="exampleClass">
			<xsl:if test="ancestor::verticalCrossword/word[@id=$wordId]/@example='y'">example</xsl:if>
		</xsl:variable>

		<li id="clue-{$verticalCrosswordId}-{$wordId}" class="{normalize-space(concat('clue ', $exampleClass))}" data-wordId="{@wordId}">
			<xsl:if test="$exampleClass!='example'">
				<xsl:attribute name="tabindex">0</xsl:attribute>
			</xsl:if>

			<span class="crosswordClueNumber">
				<span class="crosswordClueNumbering"><xsl:value-of select="$precedingWordsCount"/></span>
				<span class="crosswordClueNumberingPunctuation">.</span>
			</span>&#160;
			<xsl:apply-templates />
		</li>
	</xsl:template>

	<xsl:template match="verticalCrossword/crossingWordClue">
		<div tabindex="0" class="crossingWordClue">
			<xsl:choose>
				<xsl:when test="@label and not(@label='')">
					<h3><xsl:value-of select="@label"/></h3>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="data-rcfTranslate"></xsl:attribute>
					<xsl:attribute name="aria-label">[ interactions.verticalCrossword.clue ]</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<p>
				<xsl:apply-templates/>
			</p>
		</div>
	</xsl:template>

	<xsl:template match="verticalCrossword/crossingWordClue/crossingWord">
		<span class="crossingWordContainer" data-rcfTranslate="" aria-label="[ interactions.verticalCrossword.crossingWordContainer ]">
			<xsl:for-each select="ancestor::verticalCrossword/word">
				<xsl:variable name="ariaLabel"><xsl:if test="not(@example='y')">[ interactions.verticalCrossword.blank ]</xsl:if></xsl:variable>
				<span class="crossingWordLetter" data-rcfTranslate="" aria-label="{$ariaLabel}">
					<xsl:if test="not(@example='y')">_</xsl:if>
					<xsl:if test="@example='y'"><xsl:value-of select="@letter"/></xsl:if>
				</span>
			</xsl:for-each>
		</span>
	</xsl:template>

	<xsl:template name="outputSpacing">
		<xsl:param name="numBlanks" />
		<xsl:param name="blankCounter" select="'1'"/>
		<td class="vcSpacer"> </td>
		<xsl:if test="$blankCounter &lt; $numBlanks">
			<xsl:call-template name="outputSpacing">
				<xsl:with-param name="numBlanks" select="$numBlanks"/>
				<xsl:with-param name="blankCounter" select="$blankCounter + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="outputTypeins">
		<xsl:param name="answerValue"/>
		<xsl:param name="exampleCrossingWord" select="'n'"/>
		<xsl:param name="isExample" select="'n'"/>
		<xsl:param name="useLetter" />
		<xsl:param name="firstLetterExample" select="'n'"/>
		<xsl:call-template name="outputLetters">
			<xsl:with-param name="answerValue" select="$answerValue"/>
			<xsl:with-param name="exampleCrossingWord" select="$exampleCrossingWord"/>
			<xsl:with-param name="isExample" select="$isExample"/>
			<xsl:with-param name="useLetter" select="$useLetter"/>
			<xsl:with-param name="firstLetterExample" select="$firstLetterExample"/>
		</xsl:call-template>
		<td class="vcMark"><span class="markContainer"><span class="mark">&#160;&#160;&#160;&#160;</span></span></td>
	</xsl:template>

	<xsl:template name="outputLetters">
		<xsl:param name="answerValue"/>
		<xsl:param name="exampleCrossingWord" select="'n'"/>
		<xsl:param name="isExample" select="'n'"/>
		<xsl:param name="position" select="'1'"/>
		<xsl:param name="useLetter"/>
		<xsl:param name="firstLetterExample" />

		<xsl:variable name="firstPosition"><xsl:value-of select="string-length(substring-before($answerValue, $useLetter))+1"/></xsl:variable>
		<xsl:variable name="currentLetter"><xsl:value-of select="substring($answerValue, $position, 1)"/></xsl:variable>
		<xsl:variable name="isCrossingLetter"><xsl:if test="$useLetter = $currentLetter and $position=$firstPosition">y</xsl:if></xsl:variable>
		<xsl:variable name="inputClass">
			vcTypeIn
			<xsl:if test="$isCrossingLetter = 'y'"> hiddenLetter </xsl:if>
			<xsl:if test="$isExample='y' or $firstLetterExample='y'"> example </xsl:if>
			<xsl:if test="$currentLetter = ' '"> spaceCell </xsl:if>
			<xsl:if test="($isCrossingLetter='y' and $exampleCrossingWord='y') or ($currentLetter = ' ')"> skippableCell </xsl:if>
		</xsl:variable>

		<td class="vcLetter">
			<input type="text"
				class="{normalize-space($inputClass)}"
				maxlength="1"
				size="1"
				autocomplete="off"
				autocapitalize="off"
				spellcheck="false"
				autocorrect="off"
			>
				<xsl:if test="($isExample='y' or $currentLetter=' ' or $firstLetterExample='y') or ($isCrossingLetter = 'y' and $exampleCrossingWord = 'y')">
					<xsl:attribute name="readonly"/>
					<xsl:attribute name="tabIndex">-1</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$currentLetter"/></xsl:attribute>
					<xsl:attribute name="disabled"/>
				</xsl:if>

			</input>
		</td>
		<xsl:if test="$position &lt; string-length($answerValue)">
			<xsl:call-template name="outputLetters">
				<xsl:with-param name="answerValue" select="$answerValue"/>
				<xsl:with-param name="exampleCrossingWord" select="$exampleCrossingWord"/>
				<xsl:with-param name="isExample" select="$isExample"/>
				<xsl:with-param name="position" select="$position+1"/>
				<xsl:with-param name="useLetter" select="$useLetter"/>
				<xsl:with-param name="firstLetterExample" select="'n'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- rcf_vertical_crossword -->
	<xsl:template match="verticalCrossword" mode="getRcfClassName">
		rcfVerticalCrossword
	</xsl:template>

</xsl:stylesheet>
