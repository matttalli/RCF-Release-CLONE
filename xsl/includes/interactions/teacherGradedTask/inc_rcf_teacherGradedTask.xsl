<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="teacherGradedTask">
		<xsl:variable name="hasMarkingGuidanceClass">
			<xsl:if test="markingGuidance">hasMarkingGuidance</xsl:if>
		</xsl:variable>
		<xsl:variable name="maxScore">
			<xsl:call-template name="getTeacherGradedTaskMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('block teacherGradedTaskContainer ', @class, ' ' , $hasMarkingGuidanceClass))}"
			data-rcfid="{@id}"
			data-disableOpenGradableTeacherComments="{$disableOpenGradableTeacherComments}"
			data-rcfinteraction="teacherGradedTask"
			data-ignoreNextAnswer="y"
			data-maxScore="{$maxScore}"
		>
			<xsl:apply-templates select="." mode="outputTeacherGradedTaskLeaveTeacherFeedbackHtml"/>
			<xsl:apply-templates select="." mode="outputTeacherGradedTaskReviewTeacherFeedbackHtml"/>
		</div>
	</xsl:template>


	<xsl:template match="teacherGradedTask" mode="outputTeacherGradedTaskLeaveTeacherFeedbackHtml">
		<xsl:variable name="maxScore">
			<xsl:call-template name="getTeacherGradedTaskMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="teacherFeedbackInteractions">
			<xsl:if test="markingGuidance">
				<div class="block markingGuidanceBlock">
					<p>
						<xsl:apply-templates select="markingGuidance"/>
					</p>
				</div>
			</xsl:if>

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
				<h3 class="teacherCommentLabel" data-rcfTranslate="">[ interactions.teacherGradedTask.teacherComment ]</h3>
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

	<xsl:template match="teacherGradedTask" mode="outputTeacherGradedTaskReviewTeacherFeedbackHtml">
		<xsl:variable name="maxScore">
			<xsl:call-template name="getTeacherGradedTaskMaxScore">
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

	<xsl:template name="getTeacherGradedTaskMaxScore">
		<xsl:param name="max_score" select="'5'"/>
		<xsl:choose>
			<xsl:when test="$max_score != ''">
				<xsl:value-of select="$max_score"/>
			</xsl:when>
			<xsl:otherwise>5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="teacherGradedTask" mode="getOpenGradableInteractionName">
		rcfTeacherGradedTask
	</xsl:template>

</xsl:stylesheet>
