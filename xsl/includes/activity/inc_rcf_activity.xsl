<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:include href="./activityHead/inc_rcf_activityhead.xsl"/>

	<xsl:template match="activity">
		<!-- get the gradable type of the activity -->
		<xsl:variable name="activityGradableType">
			<xsl:call-template name="getActivityGradableType">
				<xsl:with-param name="activityNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<!-- get points available for this activity -->
		<xsl:variable name="activityPoints">
			<xsl:call-template name="getActivityPointsForGradableType">
				<xsl:with-param name="activityNode" select="."/>
				<xsl:with-param name="gradableType" select="$activityGradableType"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- place it into a variable to go into the <div class="activity...."> element as a data-attribute -->
		<xsl:variable name="activityPointsAvailable">
			<xsl:choose>
				<xsl:when test="$activityPoints!=''"><xsl:value-of select="normalize-space($activityPoints)"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- calculate any teacher points available for open-gradable interactions inside the activity -->
		<xsl:variable name="teacherPointsAvailable">
			<xsl:call-template name="teacherPointsAvailable"><xsl:with-param name="activityNode" select="."/></xsl:call-template>
		</xsl:variable>

		<!-- get the 'marked' class for this activity -->
		<xsl:variable name="markedClass">
			<xsl:choose>
				<xsl:when test="@marked='y' or not(@marked)">marked</xsl:when>
				<xsl:otherwise>unmarked</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- item based elements -->
		<xsl:variable name="isItemBased">
			<xsl:choose>
				<xsl:when test="$itemsFileName">y</xsl:when>
				<xsl:when test="count(//itemBased)>0">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- determine the types of interaction inside this activity, this tells the code the type of controller objects to create -->
		<!-- get all the 'marked' interactions -->
		<xsl:variable name="interactions">
			<xsl:call-template name="getInteractionsInElement">
				<xsl:with-param name="rootNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<!-- currently, only 'categorise' has different 'interactions' for mobile/desktoop interactions when using desktop/mobile/tablet rendering -->
		<xsl:variable name="mobileInteractions">
			<xsl:call-template name="getMobileOnlyInteractionsInElement">
				<xsl:with-param name="rootNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="desktopInteractions">
			<xsl:call-template name="getDesktopOnlyInteractionsInElement">
				<xsl:with-param name="rootNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="openGradableInteractions">
			<xsl:call-template name="getOpenGradableInteractionsInElement">
				<xsl:with-param name="rootNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="unmarkedInteractions">
			<xsl:call-template name="getUnmarkedInteractionsInElement">
				<xsl:with-param name="rootNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="numberedClass">
			<xsl:if test="@numbered='n'"> unnumbered</xsl:if>
		</xsl:variable>

		<!-- RCF-265 -->
		<xsl:variable name="internalPseudoID">
			<xsl:choose>
				<xsl:when test="@pseudoID"><xsl:value-of select="@pseudoID"/></xsl:when>
				<xsl:when test="$pseudoID"><xsl:value-of select="$pseudoID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isInteractive">
			<xsl:choose>
				<xsl:when test="@interactive='n'">n</xsl:when>
				<xsl:otherwise>y</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isAnswerKey">
			<xsl:choose>
				<xsl:when test="(metadata/isAnswerKey='y') or (main/answerKey)">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isTeacherTip">
			<xsl:choose>
				<xsl:when test="metadata/isTeacherTip='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="itemBasedClass"><xsl:if test="$isItemBased='y'">itemBased</xsl:if></xsl:variable>

		<xsl:variable name="hasInteractiveClass"><xsl:if test="count(//interactive) &gt; 0">hasInteractive</xsl:if></xsl:variable>
		<xsl:variable name="hasPresentationClass"><xsl:if test="count(//presentation) &gt; 0">hasPresentation</xsl:if></xsl:variable>

		<!-- get a list of all itemBased interactions -->
		<xsl:variable name="itemBasedInteractions">
			<!-- new logic to always check for /activity/itemListContainer/itemList first -->
			<xsl:choose>
				<xsl:when test="/activity/itemListContainer">
					<xsl:call-template name="getItemBasedInteractionsInElement">
						<xsl:with-param name="isItemBased" select="$isItemBased"/>
						<xsl:with-param name="itemListNode" select="/activity/itemListContainer/itemList"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$environment='capePreview'">
					<xsl:call-template name="getItemBasedInteractionsInElement">
						<xsl:with-param name="isItemBased" select="$isItemBased"/>
						<xsl:with-param name="itemListNode" select="/activity/itemListContainer/itemList"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getItemBasedInteractionsInElement">
						<xsl:with-param name="isItemBased" select="$isItemBased"/>
						<xsl:with-param name="itemListNode" select="document($itemsFileName)"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- sticky wordpool class (if any) *ALWAYS* overridden by fixed word pool setting -->
		<xsl:variable name="stickyWordPoolsClass">
			<xsl:choose>
				<xsl:when test="$useFixedWordPools='y'"></xsl:when>
				<xsl:when test="@stickyWordPools='y'">wordbox-position-<xsl:value-of select="$wordBoxPosition"/></xsl:when>
				<xsl:when test="@stickyWordPools='n'"></xsl:when>
				<xsl:when test="$stickyWordPools='y'">wordbox-position-<xsl:value-of select="$wordBoxPosition"/></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="useStickyWordPools">
			<xsl:choose>
				<xsl:when test="$useFixedWordPools='y'">n</xsl:when>
				<xsl:when test="@stickyWordPools='y'">y</xsl:when>
				<xsl:when test="@stickyWordPools='n'">n</xsl:when>
				<xsl:when test="$stickyWordPools='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mediaOnlyActivity"><xsl:if test="count(media)>0">y</xsl:if></xsl:variable>
		<xsl:variable name="mediaOnlyClass"><xsl:if test="$mediaOnlyActivity='y'">dev-mediaActivity</xsl:if></xsl:variable>
		<xsl:variable name="disableOpenGradableTeacherCommentsClass"><xsl:if test="$disableOpenGradableTeacherComments='y'">dev-disable-opengradable-teacher-comments</xsl:if></xsl:variable>

		<xsl:variable name="activityMode">
			<xsl:variable name="detectedMode"><xsl:apply-templates select="." mode="getActivityMode"/></xsl:variable>
			<xsl:value-of select="normalize-space($detectedMode)"/>
		</xsl:variable>

		<xsl:variable name="enableMathJax">
			<xsl:choose>
				<xsl:when test="@enableMathJax='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="pointsMultiplier">
			<xsl:call-template name="getPointsMultiplier">
				<xsl:with-param name="activityMode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="referenceContentIds">
			<xsl:call-template name="getReferenceContentIdsInActivity" />
		</xsl:variable>

		<div class="activityContainer {$levelName}">
			<xsl:comment>Generated with RCF version <xsl:value-of select="$rcfVersion"/></xsl:comment>
			<div class="{normalize-space(concat('dev-rcf-content activity ', @class, ' ', $numberedClass, ' ', $itemBasedClass, ' ', $markedClass,  ' ', $stickyWordPoolsClass, ' ', $mediaOnlyClass, ' ', $disableOpenGradableTeacherCommentsClass, ' ', $hasInteractiveClass, ' ', $hasPresentationClass))}"
				id="{@id}"
				data-activitymodes="{$activityMode}"
				data-pseudoid="{$internalPseudoID}"
				data-rcfxmlid="{@id}"
				data-pointsAvailable="{$activityPointsAvailable}"
				data-teacherPointsAvailable="{$teacherPointsAvailable}"
				data-pointsMultiplier="{$pointsMultiplier}"
				data-sharedassetsurl="{$sharedAssetsURL}"
				data-levelassetsurl="{$levelAssetsURL}"
				data-interactions="{normalize-space($interactions)}"
				data-mobileinteractions="{$mobileInteractions}"
				data-desktopinteractions="{$desktopInteractions}"
				data-itemBasedInteractions="{$itemBasedInteractions}"
				data-openGradableInteractions="{$openGradableInteractions}"
				data-unmarkedInteractions="{$unmarkedInteractions}"
				data-isInteractive="{$isInteractive}"
				data-gradableType="{$activityGradableType}"
				data-isAnswerKey="{$isAnswerKey}"
				data-isTeacherTip="{$isTeacherTip}"
				data-isItemBased="{$isItemBased}"
				data-mobileDragDrop="{$mobileDragDrop}"
				data-environment="{$environment}"
				data-dropdownListOutput="{$dropDownListOutput}"
				data-stickyWordPools="{$useStickyWordPools}"
				data-fixedWordPools="{$useFixedWordPools}"
				data-disableOpenGradableTeacherComments="{$disableOpenGradableTeacherComments}"
				data-collapsibleWordPools="{$collapsibleWordBox}"
				data-enableMathJax="{$enableMathJax}"
				data-penaliseWrongAnswers="{$penaliseWrongAnswers}"
				data-randomizeItems="{@randomizeItems}"
				data-sortItemsAlphabetically="{@sortItemsAlphabetically}"
			>
				<xsl:if test="@seed">
					<xsl:attribute name="data-seed"><xsl:value-of select="@seed"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@desktopDraggable">
					<xsl:attribute name="data-desktopdraggable"><xsl:value-of select="@desktopDraggable"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@droppableClickStick">
					<xsl:attribute name="data-droppableclickstick"><xsl:value-of select="@droppableClickStick"/></xsl:attribute>
				</xsl:if>

				<xsl:if test="$referenceContentIds!=''">
					<xsl:attribute name="data-rcfReferenceContentIds"><xsl:value-of select="$referenceContentIds"/></xsl:attribute>
				</xsl:if>

				<xsl:if test="@lang">
					<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
				</xsl:if>

				<form onsubmit="return false;">
					<!-- single audio player per activity for smaller players -->
					<div class="activityAudioPlayerContainer audioContainer">
						<audio id="{@id}_activityAudioPlayer" class="activityAudioPlayer" crossorigin="" playsinline="" preload="auto" nocontrols=""/>
					</div>

					<!-- aria live region per activity to allow screen reader announcements -->
					<div id="{@id}_ariaLive" aria-live="assertive" role="status" class="globalAriaLive visually-hidden" tabindex="-1"></div>

					<xsl:choose>
						<xsl:when test="$mediaOnlyActivity='y'">
							<div class="backgroundArea">
								<!-- output the rest of the activity -->
								<xsl:apply-templates select="media"/>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<!-- output activity titles / subtitles / descriptions etc -->
							<xsl:apply-templates select="activityHead" mode="outputActivityHeader" />
							<!-- output the rubric -->
							<xsl:call-template name="outputRubrics"/>
							<!-- output the activity contents -->
							<div class="backgroundArea">
								<!-- output the rest of the activity -->
								<xsl:apply-templates/>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</form>

				<xsl:if test="count(media)=0">
					<div class="rcfFlashcardMask"></div>
				</xsl:if>

			</div>

			<xsl:if test="not($mediaOnlyActivity='y')">
				<div class="rcfInteractiveMask"></div>
			</xsl:if>

		</div>

	</xsl:template>

	<xsl:template name="getReferenceContentIdsInActivity">
		<xsl:variable name="referenceContentIds">
			<xsl:for-each select="//presentation/@referenceId">
				<xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:call-template name="removeDuplicates">
			<xsl:with-param name="string" select="normalize-space($referenceContentIds)"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template match="text()" mode="pointsCalculation"/>
	<xsl:template match="text()" mode="interactionCount"/>
	<xsl:template match="text()" mode="teacherPointsCalculation"/>
	<xsl:template match="text()" mode="itemBasedPointsCalculation"/>
</xsl:stylesheet>
