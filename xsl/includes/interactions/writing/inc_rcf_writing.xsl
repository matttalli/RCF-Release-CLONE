<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:include href="../answerModel/inc_rcf_answerModel.xsl"/>
	<xsl:include href="../markingGuidance/inc_rcf_markingGuidance.xsl"/>

	<xsl:template match="writing">
		<!-- writing container / interaction level -->
		<xsl:variable name="hasAnswerKeyClass">
			<xsl:if test="answerModel">hasAnswerKey</xsl:if>
		</xsl:variable>
		<xsl:variable name="hasMarkingGuidanceClass">
			<xsl:if test="markingGuidance">hasMarkingGuidance</xsl:if>
		</xsl:variable>
		<xsl:variable name="maxScore">
			<xsl:call-template name="getWritingMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('block writingContainer ', $hasAnswerKeyClass, ' ', $hasMarkingGuidanceClass))}"
			data-rcfid="{@id}"
			data-disableOpenGradableTeacherComments="{$disableOpenGradableTeacherComments}"
			data-rcfinteraction="writing"
			data-ignoreNextAnswer="y"
			data-maxscore="{$maxScore}"
		>
			<xsl:if test="@maxChar">
				<xsl:attribute name="data-showCharacterCount">y</xsl:attribute>
				<xsl:attribute name="data-maxCharacters"><xsl:value-of select="@maxChar"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="answerModel"/>
			<xsl:apply-templates select="." mode="outputStudentHtml"/>
			<xsl:apply-templates select="." mode="outputWritingLeaveTeacherFeedbackHtml"/>
			<xsl:apply-templates select="." mode="outputWritingReviewTeacherFeedbackHtml"/>
		</div>
	</xsl:template>

	<!-- output student controls (default mode) -->
	<xsl:template match="writing" mode="outputStudentHtml">
		<xsl:variable name="maxScore">
			<xsl:call-template name="getWritingMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="maxCharPercentageValue">
			<xsl:if test="@maxChar">maxCharPercentageValue_000</xsl:if>
		</xsl:variable>

		<div class="{normalize-space(concat('studentInteractions ', $maxCharPercentageValue))}">
			<textarea class="{normalize-space(concat('writing rcfTextArea ', @class))}"
				autocomplete="off"
				autocapitalize="off"
				spellcheck="false"
				autocorrect="off"
				data-maxscore="{$maxScore}"
				data-presetAnswer="{translate(presetAnswer/text(), '&#10;', '|')}"
			>
				<xsl:copy-of select="presetAnswer/text()"/>
			</textarea>
			<xsl:if test="@maxChar">
				<span class="charactersCounter" aria-live="polite">0 / <xsl:value-of select="@maxChar"/></span>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- output teacher feedback controls (leaveTeacherFeedback mode) -->
	<xsl:template match="writing" mode="outputWritingLeaveTeacherFeedbackHtml">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<xsl:variable name="maxScore">
			<xsl:call-template name="getWritingMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="teacherFeedbackInteractions">
			<!-- RCF-10618 - output answer model (if there is one) as a collapsible block interaction -->
			<xsl:if test="answerModel">
				<xsl:apply-templates select="answerModel" mode="outputOpenGradableAnswerModel"/>
			</xsl:if>

			<xsl:if test="markingGuidance">
				<xsl:apply-templates select="markingGuidance" mode="outputOpenGradableMarkingGuidance"/>
			</xsl:if>

			<div class="studentAnswer writingReview reviewStudentAnswer">
				<!-- Populated at feedback time with clickable set of spans -->
				<p/>
			</div>
			<!--
				The popup / prompt html - moved inside the 'reviewStudentAnswer' to be inline / relative to the word clicked
			-->
			<div class="reviewPopupPrompt">
				<div class="reviewTypeinContainer">
					<h3 data-rcfTranslate="">[ interactions.writing.feedbackTitle ]</h3>
					<textarea class="reviewPopupText text"
						autocomplete="on"
						autocapitalize="on"
						spellcheck="true"
						autocorrect="on"></textarea>
					<div class="textControls clearfix">
						<a class="cancelButton singleButton {$rippleClass}"><span data-rcfTranslate="">[ components.button.cancel ]</span></a>
						<a class="okButton singleButton {$rippleClass}"><span data-rcfTranslate="">[ components.button.ok ]</span></a>
					</div>
				</div>
			</div>

			<div class="teacherScoringContainer">
				<p>
					<span class="scoreLabel" data-rcfTranslate="">[ components.label.score ]: </span>
					<span class="score">
						<input class="teacherScoreInput scoreInput text" type="number" name="teacherScoreInput-{@id}" min="0" max="{$maxScore}" step="0.5"/>
					</span>
					<span data-rcfTranslate="">[ components.label.outOf ]</span><xsl:text> </xsl:text>
					<span class="maxScoreLabel"><xsl:value-of select="$maxScore"/></span>
				</p>
				<p>
					<span class="scoreValidationErrors">&#160;</span>
				</p>
			</div>

			<div class="teacherInteractionComment dev-teacher-comment-container">
				<h3 class="teacherCommentLabel" data-rcfTranslate="">[ interactions.writing.teacherFeedbackTitle ]</h3>
				<div class="teacherCommentBlock">
					<textarea class="teacherInteractionCommentTextArea rcfTextArea"
						autocomplete="on"
						autocapitalize="on"
						spellcheck="true"
						autocorrect="on"
					></textarea>
					<div class="reviewTeacherInteractionComment">
						<xsl:comment>Populated at review time</xsl:comment>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- output review controls 'reviewTeacherFeedback' mode -->
	<xsl:template match="writing" mode="outputWritingReviewTeacherFeedbackHtml">
		<xsl:variable name="maxScore">
			<xsl:call-template name="getWritingMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

 		<div class="scoreContainer questionScore reviewFeedbackScore">
			<p>
				<span class="scoreLabel" data-rcfTranslate="">[ components.label.score ]: </span><xsl:text> </xsl:text><span class="score"><span class="scoreResult"></span> <span data-rcfTranslate="">[ components.label.outOf ]</span><xsl:text> </xsl:text><xsl:value-of select="$maxScore"/><xsl:text> </xsl:text><span class="scorePercentage"></span></span>
				<span class="noMarks" data-rcfTranslate="">[ components.label.noMarks ]</span>
			</p>
		</div>
	</xsl:template>

	<!--
		new named template 'getWritingMaxScore' which will return the provided @max_score *or* the value 5 if @max_score is not provided / empty
	-->
	<xsl:template name="getWritingMaxScore">
		<xsl:param name="max_score" select="'5'"/>
		<xsl:choose>
			<xsl:when test="$max_score != ''">
				<xsl:value-of select="$max_score"/>
			</xsl:when>
			<xsl:otherwise>5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="writing" mode="getOpenGradableInteractionName">
        rcfWriting
    </xsl:template>

</xsl:stylesheet>
