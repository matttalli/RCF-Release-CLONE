<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="recording">
		<xsl:variable name="hasMarkingGuidanceClass">
			<xsl:if test="markingGuidance">hasMarkingGuidance</xsl:if>
		</xsl:variable>

		<div class="{normalize-space(concat('block recordingContainer ', $hasMarkingGuidanceClass))}"
			data-rcfid="{@id}"
			data-rcfinteraction="recording"
			data-ignoreNextAnswer="y"
			data-maxscore="{@max_score}"
		>
			<xsl:apply-templates select="." mode="noRecordingSupport"/>
			<xsl:apply-templates select="." mode="outputOpenGradableMarkingGuidance"/>
			<xsl:apply-templates select="." mode="outputStudentDefaultHtml"/>
			<xsl:apply-templates select="." mode="outputLeaveTeacherFeedbackHtml"/>
			<xsl:apply-templates select="." mode="outputReviewTeacherFeedbackHtml"/>
		</div>
	</xsl:template>

	<xsl:template match="recording" mode="noRecordingSupport">
		<div class="block noRecordingSupport">
			<h3>Sorry, but this device and browser does not support audio recording</h3>
			<h4>Please try a desktop or laptop running a modern browser</h4>
		</div>
	</xsl:template>

	<xsl:template match="recording" mode="outputStudentDefaultHtml">
		<div class="block studentRecordingControlsContainer studentOpenInteractionsContainer">
			<div class="block userIconInteractionContainer" role="region" aria-labelledby="studentRecorderDescription">
				<div class="userIcon studentIcon">
					<span id="studentRecorderDescription" class="visually-hidden" data-rcfTranslate="">
						[components.userIcons.studentRecordedAnswer]
					</span>
				</div>
				<div class="userOpenContent" role="group">
					<div class="block recordingAudioContainer audioRecorder studentAudioRecorder"
						tabindex="0"
						aria-describedby="studentRecorderAnswer">
						<xsl:call-template name="outputFullRecordingHtml">
							<xsl:with-param name="interactionId" select="concat('studentRecording-', @id)"/>
							<xsl:with-param name="recordingClass" select="'studentRecording'"/>
						</xsl:call-template>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="recording" mode="outputLeaveTeacherFeedbackHtml">
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<div class="block teacherLeaveFeedbackInteractions studentOpenInteractionsContainer">
			<div class="block studentRecordedAudio recordedAudioContainer userIconInteractionContainer" role="region" aria-labelledby="studentRecordedAudio">
				<div class="userIcon studentIcon">
					<span id="studentRecordedAudio" class="visually-hidden" data-rcfTranslate="">[components.userIcons.studentRecordedAudio]</span>
				</div>
				<div class="userOpenContent" role="group">
					<div class="block recordingAudioContainer recordedAudioContainer" tabindex="0" aria-describedby="studentRecordedAudio">
						<xsl:call-template name="outputFeedbackAudioPlayer">
							<xsl:with-param name="activityNode" select="ancestor::activity"/>
							<xsl:with-param name="audioPlayerID" select="concat('studentRecording-', @id)"/>
						</xsl:call-template>
					</div>
				</div>
			</div>

			<div class="block teacherLeaveFeedbackContainer">
				<div class="feedbackTabs" role="tablist" aria-label="Feedback Tabs"> <!-- Missing translation -->
					<button role="tab" aria-selected="true" aria-controls="panel_1_{@id}"  aria-label="[ components.label.scoreThisRecording ]" id="tab_1_{@id}" name="tabGroup_{@id}" class="tab1 tab" tabindex="0" data-rcfTranslate="">[components.label.scoreTab]</button>
					<button role="tab" aria-selected="false" aria-controls="panel_2_{@id}" aria-label="[ components.label.provideWrittenFeedback ]" id="tab_2_{@id}" name="tabGroup_{@id}" class="tab2 tab" tabindex="-1" data-rcfTranslate="">[components.label.feedback]</button>
    				<button role="tab" aria-selected="false" aria-controls="panel_3_{@id}" aria-label="[ components.label.provideRecordedFeedback ]" id="tab_3_{@id}" name="tabGroup_{@id}" class="tab3 tab" tabindex="-1" data-rcfTranslate="">[components.label.record]</button>
				</div>

				<div class="tabContent tab1" id="panel_1_{@id}" role="tabpanel" aria-labelledby="tab_1_{@id}">
					<div class="scoringContainer questionScore teacherScoring">
						<p>
							<label for="teacherScoreInput-{@id}" class="scoreLabel" data-rcfTranslate="">[components.label.openGradableTeacherScoreInput]: </label>
							<span class="score">
								<input class="teacherScoreInput scoreInput text" type="number" name="teacherScoreInput-{@id}" id="teacherScoreInput-{@id}" min="0" max="{@max_score}" step="0.5"></input>
								<span data-rcfTranslate="">[components.label.outOf]</span>
								<span class="maxScoreLabel"><xsl:value-of select="@max_score"/></span>
							</span>
						</p>
						<p>
							<span class="scoreValidationErrors">&#160;</span>
						</p>
					</div>
				</div>

				<div class="tabContent tab2" id="panel_2_{@id}" role="tabpanel" aria-labelledby="tab_2_{@id}">
					<div class="commentContainer">
						<textarea class="teacherInteractionCommentTextArea commentTextArea rcfTextArea" aria-describedby="tab_2_{@id}"
							autocomplete="off"
							autocapitalize="off"
							spellcheck="false"
							autocorrect="off"
						></textarea>
					</div>
				</div>

				<div class="tabContent tab3" id="panel_3_{@id}" role="tabpanel" aria-labelledby="tab_3_{@id}">
					<div class="block teacherOpenInteractionsContainer teacherRecordingControls feedbackRecordingControls ">
						<div class="block userIconInteractionContainer" role="region" aria-labelledby="teachersRecordedFeedback">
							<div class="userIcon teacherIcon">
								<span id="teachersRecordedFeedback" class="visually-hidden" data-rcfTranslate="">[components.userIcons.teachersRecordedFeedback]</span>
							</div>
							<div class="userOpenContent" role="group">
								<div class="block audioRecorder teacherAudioRecorder recordingAudioContainer" tabindex="0" aria-describedby="teachersRecordedFeedback">
									<xsl:call-template name="outputFullRecordingHtml">
										<xsl:with-param name="interactionId" select="concat('teacherRecording-', @id)"/>
										<xsl:with-param name="recordingClass" select="'teacherRecording'"/>
									</xsl:call-template>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</xsl:template>

	<xsl:template match="recording" mode="outputReviewTeacherFeedbackHtml">
		<div class="block reviewFeedbackInteractions">
			<div class="block studentOpenInteractionsContainer">
				<div class="block userIconInteractionContainer" role="region" aria-labelledby="reviewStudentRecordedAnswer">
					<div class="userIcon studentIcon">
						<span id="reviewStudentRecordedAnswer" class="visually-hidden" data-rcfTranslate="">[components.userIcons.studentRecordedAnswer]</span>
					</div>
					<div class="userOpenContent" role="group">
						<div class="block studentRecordedAudio recordingAudioContainer recordedAudioContainer ">
							<xsl:call-template name="outputFeedbackAudioPlayer">
								<xsl:with-param name="activityNode" select="ancestor::activity"/>
								<xsl:with-param name="audioPlayerID" select="concat('studentReviewedRecording-', @id)"/>
							</xsl:call-template>
						</div>
					</div>
				</div>
			</div>
			<div class="block teacherOpenInteractionsContainer">
				<div class="block teacherFeedbackAudioContainer teacherRecordingPanel userIconInteractionContainer" role="region" aria-labelledby="reviewTeachersRecordedFeedback">
					<div class="userIcon teacherIcon">
						<span id="reviewTeachersRecordedFeedback" class="visually-hidden" data-rcfTranslate="">[components.userIcons.teachersRecordedFeedback]</span>
					</div>
					<div class="userOpenContent" role="group">
						<div class="block teacherFeedbackAudio recordingAudioContainer recordedAudioContainter ">
							<xsl:call-template name="outputFeedbackAudioPlayer">
								<xsl:with-param name="activityNode" select="ancestor::activity"/>
								<xsl:with-param name="audioPlayerID" select="concat('studentOriginalRecording-', @id)"/>
							</xsl:call-template>
						</div>
					</div>
				</div>
				<div class="teacherCommentContainer userIconInteractionContainer dev-teacher-comment-container" role="region" aria-labelledby="reviewTeachersWrittenFeedback">
					<div class="userIcon teacherIcon">
						<span id="reviewTeachersWrittenFeedback" class="visually-hidden" data-rcfTranslate="">[components.userIcons.teachersWrittenFeedback]</span>
					</div>
					<div class="userOpenContent" role="group">
						<div class="commentContainer">
							<div class="commentText reviewTeacherInteractionComment" tabindex="0" aria-describedby="reviewTeachersWrittenFeedback">

							</div>
						</div>
					</div>
				</div>

				<div class="scoreContainer questionScore reviewFeedbackScore">
					<p>
						<span class="scoreLabel" data-rcfTranslate="">[ components.label.score ]: </span>
						<xsl:text> </xsl:text>
						<span class="score">
							<span class="scoreResult"></span>
							<span data-rcfTranslate="">[ components.label.outOf ]</span>
							<xsl:value-of select="@max_score"/>
							<xsl:text> </xsl:text>
							<span class="scorePercentage"></span>
						</span>
						<span class="noMarks" data-rcfTranslate="">[ components.label.noMarks ]</span>
					</p>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="outputFullRecordingHtml">
		<xsl:param name="interactionName">audioRecorder</xsl:param>
		<xsl:param name="interactionId"/>
		<xsl:param name="recordingClass"/>

		<div data-rcfinteraction="{$interactionName}"
			data-rcfid="{$interactionId}"
			data-ignoreNextAnswer="y"
			class="{normalize-space(concat('largeAudioRecording ', $recordingClass, ' wasmRecording'))}"
		>
			<div class="largeAudioRecordingPanel">
				<div class="audioRecordingControls">
					<button class="audioRecordButton" data-rcf-media="record" type="button">
						<xsl:call-template name="audioStartRecordIcon"/>
						<xsl:call-template name="audioStopRecordIcon"/>
						<span class="audioRecordButtonRecordLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.record ]</span>
						<span class="audioRecordButtonStopLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.stop ]</span>
					</button>
					<button class="audioRecordPlaybackButton" disabled="" data-rcf-media="playbackRecording" type="button">
						<xsl:call-template name="audioPlayIcon"/>
						<xsl:call-template name="audioPauseIcon"/>
						<span class="audioRecordPlaybackButtonLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.play ]</span>
						<span class="audioRecordPausePlaybackButtonLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.pause ]</span>
					</button>
					<button class="audioRecordStopPlaybackButton" disabled="" data-rcf-media="stopPlaybackRecording" type="button">
						<xsl:call-template name="audioStopIcon"/>
						<span class="audioRecordStopPlaybackButtonLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.stop ]</span>
					</button>
					<div class="recordingProgressContainer">
						<div class="recordingProgressWrapper">
							<progress class="recordingProgressElement" min="0" max="100" value="0" role="progressbar" aria-hidden="true" data-rcf-media="recordingProgressBar"></progress>
						</div>
					</div>
					<div class="recordingTimes">
						<span class="recordingCurrentTime" data-rcf-media="recordingCurrentTime">00:00</span>
						<span class="recordingTotalTime" data-rcf-media="recordingTotalTime">00:00</span>
					</div>
				</div>

			</div>
			<audio class="playbackPlayer" crossorigin="" playsinline="" data-rcf-media="playbackAudioPlayer"></audio>

		</div>
	</xsl:template>

	<xsl:template name="outputFeedbackAudioPlayer">
		<xsl:param name="activityNode"/>
		<xsl:param name="audioPlayerID"/>

		<xsl:variable name="apID"><xsl:value-of select="$activityNode/@id"/>-<xsl:value-of select="$audioPlayerID"/></xsl:variable>

		<div id="{$activityNode/@id}-{$audioPlayerID}_lap-recording"
			data-rcfinteraction="audioElement"
			data-ignoreNextAnswer="y"
			class="audio large audioContainer noSubtitles" data-audiosrc=""
		>
			<div id="audioPlayer_{$apID}"
				class="audioPlayer"
				data-audiosrc=""
				data-size="large"
			>

			</div>

			<div id="audioPlayerInterface_{$apID}" class="audioInterface">
 				<audio class="audioPlayer" crossorigin="" playsinline=""/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="recording[@markedByTeacher='y']" mode="getOpenGradableInteractionName">
        rcfRecording
	</xsl:template>

	<xsl:template match="recording[not(@markedByTeacher) or @markedByTeacher='n']" mode="getUnmarkedInteractionName">
		rcfRecording
	</xsl:template>

</xsl:stylesheet>
