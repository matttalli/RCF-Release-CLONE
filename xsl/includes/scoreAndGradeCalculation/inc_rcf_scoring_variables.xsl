<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
>
	<!--
		This template calculates the available points in an activity - takes into account:
			- 'example' attributes
			- 'marked' attributes on the activity
			- 'mark' attributes on 'ordering', 'complexOrdering' and 'positioning' interactions

		Also includes activityGradable calculation named template
	-->

	<!-- all points calculations and 'interaction counting' is now down by the templates in the ./interactions folder relative to this file -->
	<xsl:include href="./interactions/categorise.xsl"/>
	<xsl:include href="./interactions/checkbox.xsl"/>
	<xsl:include href="./interactions/complexOrdering.xsl"/>
	<xsl:include href="./interactions/complexCategorise.xsl"/>
	<xsl:include href="./interactions/complexDroppable.xsl"/>
	<xsl:include href="./interactions/complexMatching.xsl"/>
	<xsl:include href="./interactions/crossword.xsl"/>
	<xsl:include href="./interactions/dropdown.xsl"/>
	<xsl:include href="./interactions/droppable.xsl"/>
	<xsl:include href="./interactions/findInImage.xsl"/>
	<xsl:include href="./interactions/fixedCrossword.xsl"/>
	<xsl:include href="./interactions/fixedWordSearch.xsl"/>
	<xsl:include href="./interactions/freeDrawing.xsl"/>
	<xsl:include href="./interactions/inlineOrdering.xsl"/>
	<xsl:include href="./interactions/interactiveTextBlock.xsl"/>
	<xsl:include href="./interactions/itemBasedCheckbox.xsl"/>
	<xsl:include href="./interactions/itemBasedComplexDroppableBlock.xsl"/>
	<xsl:include href="./interactions/itemBasedDropDown.xsl"/>
	<xsl:include href="./interactions/itemBasedRadio.xsl"/>
	<xsl:include href="./interactions/itemBasedSelectableText.xsl"/>
	<xsl:include href="./interactions/itemBasedSentenceBuilder.xsl"/>
	<xsl:include href="./interactions/itemBasedTypein.xsl"/>
	<xsl:include href="./interactions/itemBasedTypeinGroup.xsl"/>
	<xsl:include href="./interactions/itemBasedWordInsert.xsl"/>
	<xsl:include href="./interactions/listenAndColour.xsl"/>
	<xsl:include href="./interactions/locating.xsl"/>
	<xsl:include href="./interactions/matching.xsl"/>
	<xsl:include href="./interactions/mathsAddition.xsl"/>
	<xsl:include href="./interactions/mathsDivision.xsl"/>
	<xsl:include href="./interactions/mathsMultiplication.xsl"/>
	<xsl:include href="./interactions/mathsSubtraction.xsl"/>
	<xsl:include href="./interactions/mlTextInput.xsl"/>
	<xsl:include href="./interactions/mlTypein.xsl"/>
	<xsl:include href="./interactions/ordering.xsl"/>
	<xsl:include href="./interactions/pelmanism.xsl"/>
	<xsl:include href="./interactions/positioning.xsl"/>
	<xsl:include href="./interactions/radio.xsl"/>
	<xsl:include href="./interactions/recording.xsl"/>
	<xsl:include href="./interactions/sentenceBuilder.xsl"/>
	<xsl:include href="./interactions/teacherGradedTask.xsl"/>
	<xsl:include href="./interactions/textInput.xsl"/>
	<xsl:include href="./interactions/typein.xsl"/>
	<xsl:include href="./interactions/typeinGroup.xsl"/>
	<xsl:include href="./interactions/verticalCrossword.xsl"/>
	<xsl:include href="./interactions/wordInsert.xsl"/>
	<xsl:include href="./interactions/wordSearch.xsl"/>
	<xsl:include href="./interactions/wordSnake.xsl"/>
	<xsl:include href="./interactions/writing.xsl"/>

	<xsl:template name="activityPoints">
		<xsl:param name="activityNode" select="//activity[1]"/>
		<xsl:variable name="calculatedPointsFromInteractions">
			<xsl:choose>
				<xsl:when test="count($activityNode//answerKey) &gt; 0"><value>0</value></xsl:when>
				<xsl:when test="$activityNode/@marked='n'"><value>0</value></xsl:when>
				<xsl:otherwise><xsl:apply-templates select="$activityNode" mode="pointsCalculation"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="sum(exsl:node-set($calculatedPointsFromInteractions)/value)"/>
	</xsl:template>

	<xsl:template name="getActivityPointsForGradableType">
		<xsl:param name="activityNode" select="//activity[1]"/>
		<xsl:param name="gradableType" select="''"/>

		<xsl:choose>
			<xsl:when test="$gradableType='closed-gradable' and $activityNode/@overrideScore and $activityNode/@overrideScore > 0">
				<xsl:value-of select="$activityNode/@overrideScore"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="activityPoints">
					<xsl:with-param name="activityNode" select="$activityNode"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="itemPoints">
		<xsl:param name="item" />
		<xsl:variable name="calculatedItemBasedPointsFromInteractions">
			<xsl:apply-templates select="$item" mode="itemBasedPointsCalculation"/>
		</xsl:variable>
		<xsl:value-of select="sum(exsl:node-set($calculatedItemBasedPointsFromInteractions)/value)"/>
	</xsl:template>

	<xsl:template name="activityInteractionCount">
		<xsl:param name="activityNode" />
		<xsl:variable name="numInteractions">
			<xsl:apply-templates select="$activityNode" mode="interactionCount"/>
		</xsl:variable>
		<xsl:value-of select="sum(exsl:node-set($numInteractions)/value)"/>
	</xsl:template>

	<xsl:template name="getActivityGradableType">
		<xsl:param name="activityNode" select="//activity[1]"/>
		<xsl:choose>
			<xsl:when test="@gradable"><xsl:value-of select="@gradable"/></xsl:when>
			<xsl:when test="count($activityNode//story)>0">story</xsl:when>
			<xsl:when test="count($activityNode//itemBased)>0">item-based</xsl:when>
			<xsl:when test="count($activityNode//answerKey)>0">answer-key</xsl:when>
			<xsl:when test="count($activityNode//writing)>0">open-gradable</xsl:when>
			<xsl:when test="count($activityNode//teacherGradedTask)>0">open-gradable</xsl:when>
			<xsl:when test="count($activityNode//freeDrawing)>0">open-gradable</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="activityPointsAvailable">
					<xsl:call-template name="activityPoints">
						<xsl:with-param name="activityNode" select="$activityNode"/>
					</xsl:call-template>
				</xsl:variable>

				<!-- determine if any of the interactions will be marked by teacher -->
				<xsl:variable name="markedByTeacher"><xsl:if test="count($activityNode//*[@markedByTeacher='y'])&gt;0">y</xsl:if></xsl:variable>
				<xsl:choose>
					<xsl:when test="$markedByTeacher='y'">open-gradable</xsl:when>
					<xsl:when test="$activityPointsAvailable &lt; 1">
						<xsl:variable name="numInteractions">
							<xsl:call-template name="activityInteractionCount">
								<xsl:with-param name="activityNode" select="$activityNode"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:choose>
							<xsl:when test="$numInteractions &gt; 0 or count($activityNode//*[@marked='n'])>0">open-non-gradable</xsl:when>
							<xsl:otherwise>non-gradable</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="count($activityNode//*[@marked='n'])>0">open-non-gradable</xsl:when>
							<xsl:otherwise>closed-gradable</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="teacherPointsAvailable">
		<xsl:param name="activityNode" select="//activity[1]"/>
		<xsl:variable name="interactionsWithMaxScore">
			<xsl:value-of select="sum($activityNode//*/@max_score)"/>
		</xsl:variable>
		<xsl:variable name="writingInteractionsWithMissingScore">
			<xsl:value-of select="count($activityNode//writing[not(@max_score) or @max_score='']) * 5"/>
		</xsl:variable>
		<xsl:variable name="teacherGradedTasksWithMissingScore">
			<xsl:value-of select="count($activityNode//teacherGradedTask[not(@max_score) or @max_score='']) * 5"/>
		</xsl:variable>

		<xsl:value-of select="$interactionsWithMaxScore + $writingInteractionsWithMissingScore + $teacherGradedTasksWithMissingScore"/>
	</xsl:template>

	<xsl:template name="getPointsMultiplier">
		<xsl:param name="activityNode" select="//activity[1]"/>
		<xsl:variable name="gradableType"><xsl:call-template name="getActivityGradableType"><xsl:with-param name="activityNode" select="$activityNode"/></xsl:call-template></xsl:variable>

		<xsl:variable name="multiplier">
			<xsl:choose>
				<xsl:when test="$activityNode/@overrideScore and $activityNode/@overrideScore > 0 and $gradableType='closed-gradable'">
					<xsl:variable name="pointsAvailable">
						<xsl:call-template name="activityPoints">
							<xsl:with-param name="activityNode" select="$activityNode"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="round(($activityNode/@overrideScore div $pointsAvailable) * 100) div 100"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$multiplier"/>
	</xsl:template>

</xsl:stylesheet>
