<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	Open gradable <freeDrawing> interaction

 -->
	<xsl:template match="freeDrawing">

		<xsl:variable name="hasMarkingGuidanceClass">
			<xsl:if test="markingGuidance">hasMarkingGuidance</xsl:if>
		</xsl:variable>

		<xsl:variable name="hasAnswerKeyClass">
			<xsl:if test="answerModel">hasAnswerKey</xsl:if>
		</xsl:variable>

		<xsl:variable name="maxScore">
			<xsl:call-template name="getFreeDrawingMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('block freeDrawingInteraction ', @class, ' ', $hasAnswerKeyClass, ' ', $hasMarkingGuidanceClass))}"
			data-rcfid="{@id}"
			data-disableOpenGradableTeacherComments="{$disableOpenGradableTeacherComments}"
			data-rcfinteraction="freeDrawing"
			data-ignoreNextAnswer="y"
			data-maxScore="{$maxScore}"
		>
			<xsl:apply-templates select="." mode="outputFreeDrawingInteractionHtml"/>
			<xsl:apply-templates select="." mode="outputFreeDrawingLeaveTeacherFeedbackHtml" />
			<xsl:apply-templates select="." mode="outputFreeDrawingReviewTeacherFeedbackHtml" />
			<!-- output answer model at the end -->
			<xsl:apply-templates select="answerModel"/>
		</div>

	</xsl:template>

	<xsl:template match="freeDrawing" mode="outputFreeDrawingInteractionHtml">
		<!-- work out the src location of the desired background image -->
		<xsl:variable name="imageSrc">
			<xsl:call-template name="getAssetSource">
				<xsl:with-param name="assetSource" select="backgroundImage/@src"/>
				<xsl:with-param name="useEnvironment" select="$environment"/>
				<xsl:with-param name="assetPartialPathName" select="'images'"/>
				<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="freeDrawing-interactionContainer">
			<div class="freeDrawing-canvasContainer" tabindex="0" style="background-image: url({$imageSrc});">
				<xsl:if test="@a11yTitle">
					<xsl:attribute name="aria-label"><xsl:value-of select="@a11yTitle"/></xsl:attribute>
				</xsl:if>
				<!-- populated at runtime -->
			</div>

			<!-- toolbar - inline svgs -->
			<div class="freeDrawing-controlsContainer">
				<div class="controls">
					<!-- populate at runtime ? -->
					<button class="freeDrawing-button pencil" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.pen ]" tabindex="0" role="button" type="button">
						<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M30.0002 3.33325L36.6668 9.99992M3.3335 36.6666L5.46083 28.8664C5.59962 28.3575 5.66902 28.103 5.77555 27.8657C5.87014 27.655 5.98636 27.4548 6.12236 27.2681C6.27552 27.0579 6.46201 26.8714 6.835 26.4984L24.0574 9.27606C24.3874 8.94605 24.5524 8.78104 24.7426 8.71922C24.91 8.66483 25.0903 8.66483 25.2577 8.71922C25.448 8.78104 25.613 8.94605 25.943 9.27606L30.724 14.0571C31.054 14.3871 31.219 14.5521 31.2809 14.7424C31.3352 14.9098 31.3352 15.0901 31.2809 15.2574C31.219 15.4477 31.054 15.6127 30.724 15.9427L13.5017 33.1651C13.1287 33.5381 12.9422 33.7246 12.732 33.8777C12.5453 34.0137 12.345 34.1299 12.1344 34.2245C11.8971 34.3311 11.6426 34.4005 11.1337 34.5392L3.3335 36.6666Z" stroke="black" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>

							<!-- need to set stroke AND fill on this to change color -->
							<circle class="color-indicator" cx="8" cy="8" r="5" stroke="red" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" fill="red"/>
						</svg>
					</button>

					<button class="freeDrawing-button highlighter" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.highlighter ]" tabindex="0" role="button" type="button">
						<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40" fill="#000">
							<path d="m36.66,4.4l-2.66-2.66c-1.59-1.6-4.11-1.71-5.84-.26L8.93,17.6c-.49.41-.9.94-1.17,1.53l-1.83,4.06c-.47,1.04-.5,2.22-.12,3.26l-5.25,5.69c-.73.72-1,1.7-.71,2.55.25.72.88,1.22,1.65,1.31l4.98.09c.1,0,.19,0,.29,0,1.08,0,2.23-.52,3.14-1.42l2.07-2.08c.47.17.97.26,1.47.26.59,0,1.18-.12,1.74-.37l4.09-1.81c.61-.26,1.15-.67,1.58-1.18l16.06-19.27c1.45-1.73,1.34-4.24-.26-5.83ZM7.79,32.55c-.45.45-.9.57-1.05.55l-2.94-.06,3.85-4.17,1.91,1.91-1.77,1.77Zm10.28-4.61l-4.09,1.81c-.5.22-1.09.11-1.48-.28l-3.56-3.56c-.39-.39-.5-.99-.27-1.49l1.83-4.05c.07-.17.17-.31.31-.42l7.68,7.68c-.12.14-.26.24-.42.31Zm16.55-19.63l-14.19,17.02-7.32-7.32L30.09,3.78c.25-.21.55-.31.85-.31.34,0,.68.13.94.39l2.66,2.66c.49.49.53,1.26.08,1.79Z"></path>
							<path class="color-indicator" d="M34.9999 35.0001H21.6665" stroke="red" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path>
						</svg>
						<!-- set stroke on this to change color -->
					</button>

					<select class="freeDrawing-select brushSize" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.penSize ]">
						<option value="3" data-rcfTranslate="">[ interactions.freeDrawing.brushSize.thin ]</option>
						<option value="8" data-rcfTranslate="" selected="">[ interactions.freeDrawing.brushSize.medium ]</option>
						<option value="15" data-rcfTranslate="">[ interactions.freeDrawing.brushSize.thick ]</option>
					</select>

					<div class="freeDrawing-colorButtonsContainer">
						<button class="rcfColorButton" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.color1 ]" tabindex="0" data-color="color1" type="button"></button>
						<button class="rcfColorButton" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.color2 ]" tabindex="0" data-color="color2" type="button"></button>
						<button class="rcfColorButton" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.color3 ]" tabindex="0" data-color="color3" type="button"></button>
						<button class="rcfColorButton" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.color4 ]" tabindex="0" data-color="color4" type="button"></button>
						<button class="rcfColorButton" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.color5 ]" tabindex="0" data-color="color5" type="button"></button>
					</div>

					<div class="freeDrawing-colorPickerContainer">
						<input class="freeDrawing-colorPicker" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.colorPicker ]" tabindex="0" id="{@id}-cp" type="color" value="#000000" ></input>
					</div>

					<div class="freeDrawing-undoRedoContainer">
						<button class="freeDrawing-button promptForClearAll" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.clear ]" tabindex="0" role="button" type="button">
							<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path d="M15 5H25M5 10H35M31.6667 10L30.4979 27.5321C30.3225 30.1626 30.2348 31.4778 29.6667 32.475C29.1665 33.353 28.4121 34.0588 27.5028 34.4995C26.4699 35 25.1518 35 22.5156 35H17.4844C14.8482 35 13.5301 35 12.4972 34.4995C11.5879 34.0588 10.8335 33.353 10.3333 32.475C9.76518 31.4778 9.6775 30.1626 9.50214 27.5322L8.33333 10M16.6667 17.5V25.8333M23.3333 17.5V25.8333" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
							</svg>
						</button>

						<button class="freeDrawing-button undo" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.undo ]" tabindex="0" role="button" type="button">
							<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path d="M6.6665 11.6667H23.3332C28.856 11.6667 33.3332 16.1438 33.3332 21.6667C33.3332 27.1895 28.856 31.6667 23.3332 31.6667H6.6665M6.6665 11.6667L13.3332 5M6.6665 11.6667L13.3332 18.3333" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
							</svg>
						</button>

						<button class="freeDrawing-button redo" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.redo ]" tabindex="0" role="button" type="button">
							<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path d="M33.3332 11.6667H16.6665C11.1437 11.6667 6.6665 16.1438 6.6665 21.6667C6.6665 27.1895 11.1437 31.6667 16.6665 31.6667H33.3332M33.3332 11.6667L26.6665 5M33.3332 11.6667L26.6665 18.3333" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
							</svg>
						</button>

					</div>
				</div>

				<div class="clearDrawingPrompt" tabindex="0">
					<div class="prompt">
						<span data-rcfTranslate="">[ interactions.freeDrawing.clearDrawing ]</span>
						<span class="buttonWrapper">
							<button class="cancelClearDrawing" data-rcfTranslate="" aria-label="[ components.button.cancel ]" tabindex="0" role="button" type="button">
								<span data-rcfTranslate="">[ components.button.cancel ]</span>
							</button>
							<button class="confirmClearDrawing" data-rcfTranslate="" aria-label="[ components.button.ok ]" tabindex="0" role="button" type="button">
								<span data-rcfTranslate="">[ components.button.ok ]</span>
							</button>
						</span>
					</div>
				</div>
			</div>
		</div>

		<xsl:variable name="initialOpenStatus">
			<xsl:choose>
				<xsl:when test="@textInputExpanded='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="initialClass">
			<xsl:choose>
				<xsl:when test="$initialOpenStatus='y'">collapsibleOpen</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="supplementaryStudentsTextAnswer panel">
			<div data-rcfinteraction="collapsibleBlock"
				data-ignoreNextAnswer="y"
				class="{normalize-space(concat('block collapsibleContainer supplementaryTextAnswer ', $initialClass))}"
				data-rcfid="{@id}-supplementaryTextAnswerBlock"
				data-initialopen="{$initialOpenStatus}"
			>
				<button class="singleButton collapsibleButton" data-rcfTranslate="" aria-label="[ interactions.freeDrawing.supplementaryAnswer.ariaLabel ]" type="button">
					<span class="whenOpened innerButtonCaption" data-rcfTranslate="">[ interactions.freeDrawing.supplementaryAnswer.captionWhenOpened ]</span>
					<span class="whenClosed innerButtonCaption" data-rcfTranslate="">[ interactions.freeDrawing.supplementaryAnswer.captionWhenClosed ]</span>
				</button>

				<div class="{normalize-space(concat('block ', $initialClass))}">
					<textarea class="supplementaryTextAnswerTextArea rcfTextArea"
						autocomplete="on"
						autocapitalize="on"
						spellcheck="true"
						autocorrect="on">
					</textarea>
				</div>
			</div>
		</div>

	</xsl:template>

	<xsl:template match="freeDrawing" mode="outputFreeDrawingLeaveTeacherFeedbackHtml">
		<xsl:variable name="maxScore">
			<xsl:call-template name="getFreeDrawingMaxScore">
				<xsl:with-param name="max_score" select="@max_score"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="teacherFeedbackInteractions panel">

			<div class="studentTextAnswer freeDrawingReview reviewStudentAnswer">
				<!-- populated at review time -->
			</div>

			<xsl:apply-templates select="answerModel" mode="outputOpenGradableAnswerModel"/>
			<xsl:apply-templates select="markingGuidance" mode="outputOpenGradableMarkingGuidance"/>

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

	<xsl:template match="freeDrawing" mode="outputFreeDrawingReviewTeacherFeedbackHtml">
		<xsl:variable name="maxScore">
			<xsl:call-template name="getFreeDrawingMaxScore">
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

	<xsl:template name="getFreeDrawingMaxScore">
		<xsl:param name="max_score" select="'5'"/>
		<xsl:choose>
			<xsl:when test="$max_score != ''">
				<xsl:value-of select="$max_score"/>
			</xsl:when>
			<xsl:otherwise>5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="freeDrawing" mode="getOpenGradableInteractionName">
		rcfFreeDrawing
	</xsl:template>

</xsl:stylesheet>
