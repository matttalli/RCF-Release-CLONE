<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--

	This stylesheet is for the assessment engine *PRINT* output

	It relies on the supplied XML already being passed through the pre-process xslt (xsl/decorate-activity-for-print-generation.xsl)

	to run it (when you have xsltproc installed - pretty much all macs) :


	xsltproc xsl/decorate-activity-for-print-generation.xml <your-xml-file> | xsltproc xsl/create_rcf_print.xsl -

	That runs the xml file through the 'decorator', then passes that output to the xsltproc to run through *this* stylesheet

	The '-' parameter means to read from stdin

	You can pipe this output to a file, eg:

	xsltproc xsl/decorate-activity-for-print-generation.xml <your-xml-file> | xsltproc xsl/create_rcf_print.xsl - > output-file.html

	Then view the file in a browser etc


-->
	<xsl:output method="html" indent="no"/>

	<!-- tell the processor to strip spaces from all elements...... -->
	<xsl:strip-space elements="*"/>
	<!-- ... except for these ones -->
	<xsl:preserve-space elements="list li item p i b u sup sub strike styled td eSpan eDiv cSpan sSpan colourText code clue card matchItem matchTarget prompt"/>

	<!--
		global vars used across imported files

		Currently, we aren't passing any parameters into this transformation, but I guess we will do eventually
	-->
	<xsl:variable name="lowercaseIndex" select="'abcdefghijklmnopqrstuvwxyzñ'" />
	<!-- a variable used by the viewer, if it's not set, then you'll get errors / warnings -->
	<xsl:variable name="authoring" select="'n'"/>

	<!-- another cape variable - might be used eventually if they want to preview print ... -->
	<xsl:variable name="engineIdentifier" select="''"/>

	<!-- 'host' parameter used by cape to locate assets - setting to empty for now -->
	<xsl:param name="host" select="''"/>

	<!-- environment global variable used by CAPE processing -->
	<xsl:param name="environment" select="''"/>

	<!-- level asset url - standard provided parameter to give us the path to the level assets folder -->
	<xsl:param name="levelAssetsURL" select="'/path/to/assets'"/>

	<!-- URL (absolute or relative) to use to locate shared assets -->
	<xsl:param name="sharedAssetsURL" select="'./shared'"/>

	<!-- path to rcf.print-runtime.min.js javascript to be loaded -->
	<xsl:param name="javascriptRuntimePath" select="'./dist/rcf-release/build/js/rcf.print-runtime.min.js'"/>

	<!-- level name (Level_N) to use as a class name in the activity div -->
	<xsl:param name="levelName" select="''"/>

	<!-- seed value for randomizing lists -->
	<xsl:param name="seed" select="1234"/>

	<!-- RCF CSS URL -->
	<xsl:param name="printCssURL" select="''"/>

	<!-- RCF version being used to generate the html-->
	<xsl:param name="rcfVersion"/>

	<!-- position of wordbox, can probably hard code this for print I guess ? -->
	<xsl:variable name="wordBoxPosition" select="'default'"/>

	<!-- using fixed wordpools - I guess so ? -->
	<xsl:variable name="useFixedWordPools" select="'n'"/>

	<!-- not using collapsible word pools, but needs a value to stop warnings from imported / existing files -->
	<xsl:variable name="useCollapsibleWordPools" select="'n'"/>

	<!-- not using collapsible wordbox, again, need to set this to prevent warnings in the output -->
	<xsl:variable name="collapsibleWordBox" select="'n'"/>

	<!-- include existing files - I guess we can replace these with out own if needs be - seems a bit ott to do this though -->
	<xsl:include href="includes/inc_rcf_url_utils.xsl"/>
	<xsl:include href="includes/markup/inc_rcf_markup.xsl"/>
	<xsl:include href="includes/wordbox/inc_rcf_wordbox.xsl"/>
	<xsl:include href="includes/wordbox/inc_rcf_wordbox_collapsible_controls.xsl"/>

	<xsl:include href="print/interactions/utils.xsl"/>
	<xsl:include href="includes/inc_utils.xsl"/>

	<!-- print specific stylesheets/transformations -->
	<xsl:include href="print/interactions/answerModel.xsl"/>
	<xsl:include href="print/interactions/markingGuidance.xsl"/>

	<xsl:include href="print/interactions/static-audio-transcript.xsl"/>
	<xsl:include href="print/interactions/staticWordPool.xsl"/>
	<xsl:include href="print/interactions/drop-down.xsl"/>
	<xsl:include href="print/interactions/radioCheckbox.xsl"/>
	<xsl:include href="print/interactions/typein.xsl"/>
	<xsl:include href="print/interactions/complex-droppable.xsl"/>
	<xsl:include href="print/interactions/complex-categorise.xsl"/>

	<xsl:include href="print/interactions/maths/addition.xsl"/>
	<xsl:include href="print/interactions/maths/subtraction.xsl"/>
	<xsl:include href="print/interactions/maths/multiplication.xsl"/>
	<xsl:include href="print/interactions/maths/division.xsl"/>

	<xsl:include href="print/interactions/recording.xsl"/>
	<xsl:include href="print/interactions/ordering.xsl"/>
	<xsl:include href="print/interactions/interactiveText.xsl"/>
	<xsl:include href="print/interactions/matching.xsl"/>
	<xsl:include href="print/interactions/writing.xsl"/>
	<xsl:include href="print/interactions/free-drawing.xsl"/>

	<xsl:include href="includes/interactions/utils/inc_html_classes_utils.xsl"/>

	<!-- strip any excess whitespace -->
	<xsl:strip-space elements="*"/>

	<!-- match the root of the xml file -->
	<xsl:template match="/">
		<!-- check for an attribute added by the 'decoration' step - if it's not there, then we can't really carry on ! -->
		<xsl:if test="count(//activity[not(@preProcessed='y')])=1">
			<xsl:message terminate="yes">ERROR ! no pre processing detected
			</xsl:message>
		</xsl:if>
		<!-- output page scaffolding -->
		<xsl:comment>Generated with RCF <xsl:value-of select="$rcfVersion"/></xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="activity">
		<xsl:variable name="activityHadAudioClass"><xsl:if test=".//audio"> rcfPrint-activityHadAudio</xsl:if></xsl:variable>
		<xsl:variable name="enableMathJax">
			<xsl:choose>
				<xsl:when test="@enableMathJax='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<section id="{@id}" class="dev-rcf-content rcfPrint-activityContainer{$activityHadAudioClass}" data-enableMathJax="{$enableMathJax}">
			<xsl:if test="@seed"><xsl:attribute name="data-seed"><xsl:value-of select="@seed"/></xsl:attribute></xsl:if>
			<xsl:variable name="usePointsAvailable">
				<xsl:choose>
					<xsl:when test="@overrideScore"><xsl:value-of select="@overrideScore"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="@pointsAvailable"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:comment>activity</xsl:comment>
			<section class="rcfPrint-activity">
				<xsl:apply-templates/>
			</section>

			<xsl:variable name="answerKeyReturnValue">
				<xsl:apply-templates mode="outputAnswerKey"/>
			</xsl:variable>
			<xsl:if test="$answerKeyReturnValue!=''">
				<xsl:comment>answer key</xsl:comment>
				<section class="rcfPrint-answerKey">
					<xsl:variable name="answerCount">answer<xsl:value-of select="count(//*[@isInteraction='y' and not(@example='y')])"/></xsl:variable>
					<ol class="{$answerCount}">
						<xsl:apply-templates mode="outputAnswerKey"/>
					</ol>
				</section>
			</xsl:if>

			<xsl:if test="//staticAudioTranscript">
				<xsl:comment>static audio transcript</xsl:comment>
				<section class="rcfPrint-staticAudioTranscriptContainer">
					<xsl:apply-templates mode="outputStaticAudioTranscript"/>
				</section>
			</xsl:if>
		</section>
	</xsl:template>

	<!-- output rubric if no printRubric otherwise output print rubric -->
	<xsl:template match="rubric|printRubric">
		<xsl:if test="not(following-sibling::printRubric) and not(preceding-sibling::printRubric)">
			<div class="rcfPrint-rubric">
				<!--
					Because of odd rules in RCF-11107 then we need to be more specific about when we show the audioIcon

					complexCategorise *can* have audio / imageAudio elements, but we don't want to notify to the print output
					that there is any audio associated with it - so we need to count audio / imageAudio elements in the
					activity and any complexCategorise audio / imageAudio elements. If the totals are different, then we
					know that there is audio in the activity that is not in the complexCategorise, so we can show the icon.

				-->
				<xsl:variable name="numberOfAudioElementsInActivity" select="count(//audio)"/>
				<xsl:variable name="numberOfImageAudioElementsInActivity" select="count(//imageAudio)"/>
				<xsl:variable name="numberOfAudioElementsInComplexCategorise" select="count(//complexCategorise//audio)"/>
				<xsl:variable name="numberOfImageAudioElementsInComplexCategorise" select="count(//complexCategorise//imageAudio)"/>

				<xsl:if test="($numberOfAudioElementsInActivity  + $numberOfImageAudioElementsInActivity) != ($numberOfAudioElementsInComplexCategorise + $numberOfImageAudioElementsInComplexCategorise)">
					<xsl:call-template name="audioIcon"/>
				</xsl:if>
				<xsl:apply-templates/>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="audioIcon">
		<span class="rcfPrint-audioIcon">
			<svg width="29px" height="25px" viewBox="0 0 29 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
				<path d="M0.5 7.5 H8 L16 1 V24 L8 17.5 H0.5 Z" fill="none" fill-rule="non-zero" stroke="#000" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" opacity="0.55"></path>
				<path d="M20.5 9.5 Q21.5 12.5, 20.5 15.5" fill="none" fill-rule="non-zero" stroke="#000" stroke-width="1.3" stroke-linecap="round" opacity="0.55"></path>
				<path d="M23.5 6.5 Q25.5 12, 23.5 17.5" fill="none" fill-rule="non-zero" stroke="#000" stroke-width="1.3" stroke-linecap="round" opacity="0.55"></path>
				<path d="M26 3 Q30 12, 25.5 21.5" fill="none" fill-rule="non-zero" stroke="#000" stroke-width="1.3" stroke-linecap="round" opacity="0.55"></path>
			</svg>
		</span>
	</xsl:template>

	<xsl:template match="main">
		<div class="rcfPrint-main">
			<xsl:apply-templates/>

			<xsl:variable name="usePointsAvailable">
				<xsl:choose>
					<xsl:when test="../@overrideScore"><xsl:value-of select="../@overrideScore"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../@pointsAvailable"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- output the score box if there are any points available (this includes teacher points) -->
			<xsl:if test="$usePointsAvailable > 0">
				<div class="rcfPrint-score-area">
					<div class="rcfPrint-score">
						<div class="rcfPrint-score-label"></div>
						<div class="rcfPrint-score-value">
							<span>
								<xsl:value-of select="$usePointsAvailable"/>
							</span>
						</div>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="block">
		<div class="{normalize-space(concat('rcfPrint-block ', @class))}">
			<xsl:if test="@lang"><xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="interactive">
		<div class="{normalize-space(concat('rcfPrint-block mm_interactive rcfPrint-interactive ', @class))}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="presentation">
		<div class="{normalize-space(concat('rcfPrint-block mm_presentation rcfPrint-presentation ', @class))}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="block[@class='mm_presentation' and *[1][name()='audio'] and *[last()][name()='audio']] | presentation[*[1][name()='audio'] and *[last()][name()='audio']]">
		<!-- no output when audio is the only child in the presentation block -->
	</xsl:template>

	<xsl:template match="prompt">
		<div class="{normalize-space(concat('rcfPrint-prompt ', @class))}">
			<xsl:if test=".//audio">
				<xsl:call-template name="audioIcon"/>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="prefix">
		<span class="rcfPrint-prefix"><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match="suffix">
		<span class="rcfPrint-suffix"><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match="hint">
		<span class="rcfPrint-hint">(<xsl:apply-templates/>)</span>
	</xsl:template>


	<!-- answerkey general setup -->

	<!---
	***************************************************************************
		answer key output
	***************************************************************************
	-->

	<!-- when interaction is inside a list, output a <li> -->
	<xsl:template match="li[.//*[@isInteraction='y' and not(@example='y')]]" mode="outputAnswerKey">
		<li>
			<xsl:apply-templates mode="outputAnswerKey"/>
		</li>
	</xsl:template>

	<!-- when NOT inside a list -->
	<xsl:template match="*[@isInteraction='y']" mode="outputAnswerKey">
		<xsl:choose>
			<xsl:when test="not(ancestor::li) and not(@example='y')">
				<li>
					<xsl:apply-templates select="." mode="outputAnswerKeyValueForInteraction"/>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="outputAnswerKeyValueForInteraction"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:variable name="currentListAncestor"><xsl:value-of select="ancestor::li"/></xsl:variable>
		<xsl:if test="ancestor::li and count(following-sibling::*[@isInteraction='y' and ancestor::li=$currentListAncestor])>0">
			<span class="rcfPrint-separator">;<xsl:text> </xsl:text></span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="outputStaticAudioTranscript"/>
	<xsl:template match="text()" mode="outputAnswerKey"/>

</xsl:stylesheet>
