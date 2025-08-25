<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		This template calculates the activity mode as defined in RCF-9056
	-->

	<!-- itembased checks -->
	<xsl:template match="itemBased[@mode='practice']" mode="getActivityMode">itemBased_practice</xsl:template>
	<xsl:template match="itemBased[@mode='test']" mode="getActivityMode">itemBased_test</xsl:template>
	<xsl:template match="itemBased[@mode='challenge']" mode="getActivityMode">itemBased_challenge</xsl:template>
	<xsl:template match="itemBased[@mode='practiceChallenge']" mode="getActivityMode">itemBased_practice itemBased_challenge</xsl:template>

	<!--
		activity interaction checks

		blendedFlashcards: flashcard
		story (with questions) : story_comprehension story_reading
		story (without questions): story_reading
		media/audio: standAloneMedia_audio
		media/video: standAloneMedia_video
		findInImage: no-activity-controls
		sequenceTileMaze: no-activity-controls
		categoriseTileMaze: no-activity-controls
		balloonsGame: no-activity-controls
		bubblesGame: no-activity-controls
		barrelsGame: no-activity-controls
		snapGame: no-activity-controls
		whackaMoleGame: no-activity-controls
		quizGame: no-activity-controls
		laneChangerGame: no-activity-controls
		cogsGame: no-activity-controls
		storyDice: no-activity-controls
		spinnerGame: no-activity-controls
		spellingBee: no-activity-controls

	-->
	<xsl:template match="blendedFlashcards" mode="getActivityMode">flashcard</xsl:template>

	<xsl:template match="story[count(.//question)=0]" mode="getActivityMode">story_reading</xsl:template>
	<xsl:template match="story[count(.//question)>0]" mode="getActivityMode">story_comprehension story_reading</xsl:template>

	<xsl:template match="media/audio" mode="getActivityMode">standAloneMedia_audio</xsl:template>
	<xsl:template match="media/video" mode="getActivityMode">standAloneMedia_video</xsl:template>

	<xsl:template match="findInImage" mode="getActivityMode">no-activity-controls</xsl:template>
	<xsl:template match="sequenceTileMaze" mode="getActivityMode">no-activity-controls</xsl:template>
	<xsl:template match="categoriseTileMaze" mode="getActivityMode">no-activity-controls</xsl:template>
	<xsl:template match="balloonsGame" mode="getActivityMode">no-activity-controls</xsl:template>

	<!-- fiab games -->
	<xsl:template match="bubblesGame | barrelsGame | snapGame | whackaMoleGame | quizGame | laneChangerGame | cogsGame | storyDice | spinnerGame | spellingBee"
		mode="getActivityMode">no-activity-controls</xsl:template>

	<xsl:template match="text()" mode="getActivityMode"/>

</xsl:stylesheet>
