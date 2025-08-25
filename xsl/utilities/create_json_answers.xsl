<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
>

	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:include href="../includes/inc_utils.xsl"/>

	<xsl:include href="../includes/scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl" />
	<xsl:include href="../includes/activityModeCalculation/inc_rcf_activity_mode_calculation.xsl"/>

	<xsl:include href="./jsonAnswers/balloons_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/barrelsGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/bubblesGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/categorise_answers.xsl"/>
	<xsl:include href="./jsonAnswers/categoriseTileMaze_answers.xsl"/>
	<xsl:include href="./jsonAnswers/checkbox_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/cogsGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/complex_categorise_answers.xsl"/>
	<xsl:include href="./jsonAnswers/complex_droppable_answers.xsl"/>
	<xsl:include href="./jsonAnswers/complex_matching_answers.xsl"/>
	<xsl:include href="./jsonAnswers/complex_ordering_answers.xsl"/>
	<xsl:include href="./jsonAnswers/crossword_answers.xsl"/>
	<xsl:include href="./jsonAnswers/dropdown_answers.xsl"/>
	<xsl:include href="./jsonAnswers/droppable_answers.xsl"/>
	<xsl:include href="./jsonAnswers/findInImage_answers.xsl"/>
	<xsl:include href="./jsonAnswers/fixed_crossword_answers.xsl"/>
	<xsl:include href="./jsonAnswers/highlightingTextBlock_answers.xsl"/>
	<xsl:include href="./jsonAnswers/inline_ordering_answers.xsl"/>
	<xsl:include href="./jsonAnswers/interactivetext_nongradable_toggle_answers.xsl"/>
	<xsl:include href="./jsonAnswers/interactivetext_selectable_answers.xsl"/>
	<xsl:include href="./jsonAnswers/interactivetext_selectablecat_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/laneChangerGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/itemCheckbox_answers.xsl"/>
	<xsl:include href="./jsonAnswers/listen_and_colour_answers.xsl"/>
	<xsl:include href="./jsonAnswers/locating_answers.xsl"/>
	<xsl:include href="./jsonAnswers/matching_answers.xsl"/>
	<xsl:include href="./jsonAnswers/nongradable_answerkey_answers.xsl"/>
	<xsl:include href="./jsonAnswers/nongradable_cando_answers.xsl"/>
	<xsl:include href="./jsonAnswers/opengradable_recording_answers.xsl"/>
	<xsl:include href="./jsonAnswers/opengradable_teacherGradedTask_answers.xsl"/>
	<xsl:include href="./jsonAnswers/opengradable_textinputs_answers.xsl"/>
	<xsl:include href="./jsonAnswers/opengradable_freeDrawing_answers.xsl"/>
	<xsl:include href="./jsonAnswers/opengradable_writing_answers.xsl"/>
	<xsl:include href="./jsonAnswers/ordering_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/quizGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/pelmanism_answers.xsl"/>
	<xsl:include href="./jsonAnswers/positioning_answers.xsl"/>
	<xsl:include href="./jsonAnswers/radio_answers.xsl"/>
	<xsl:include href="./jsonAnswers/sentence_builder_answers.xsl"/>
	<xsl:include href="./jsonAnswers/sequenceTileMaze_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/snapGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/storyDice_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/spinnerGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/spellingBee_answers.xsl"/>
	<xsl:include href="./jsonAnswers/story_answers.xsl"/>
	<xsl:include href="./jsonAnswers/typein_answers.xsl"/>
	<xsl:include href="./jsonAnswers/typeingroup_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vertical_crossword_answers.xsl"/>
	<xsl:include href="./jsonAnswers/vendorGames/whackaMoleGame_answers.xsl"/>
	<xsl:include href="./jsonAnswers/wordinsert_answers.xsl"/>
	<xsl:include href="./jsonAnswers/wordsearch_answers.xsl"/>
	<xsl:include href="./jsonAnswers/wordsnake_answers.xsl"/>

	<!-- maths -->
	<xsl:include href="./jsonAnswers/maths/addition_answers.xsl"/>
	<xsl:include href="./jsonAnswers/maths/subtraction_answers.xsl"/>
	<xsl:include href="./jsonAnswers/maths/multiplication_answers.xsl"/>
	<xsl:include href="./jsonAnswers/maths/division_answers.xsl"/>


	<xsl:param name="rcfVersion"/>
	<xsl:param name="itemsFileName"/>

	<!-- marking override parameters - penaliseWrongAnswers y/n -->
	<xsl:param name="penaliseWrongAnswers" select="'n'"/>

	<!-- CAPE Parameters -->
	<xsl:param name="engineIdentifier"/>
	<xsl:param name="host"/>

	<!-- setup conversion tables for converting funky quotes / apostrophes into simple versions -->
  	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzñáéíóúü'" />
  	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÑÁÉÍÓÚÜ'" />

	<xsl:strip-space elements="item"/>

	<xsl:template match="/">
		<xsl:variable name="jsonOutput">
			<xsl:apply-templates/>
		</xsl:variable>
		<xsl:value-of select="translate($jsonOutput, '&#x9;', ' ')"/>
	</xsl:template>

	<xsl:template match="activity">
		<!-- detect any invalid answers which cannot be caught in the schema validation -
			eg. invalid data entered in a field dependent on an attribute value, or invalid expandable answers bracketing etc

			Any interaction which requires answers generation, can implement a template with mode "detectInvalidAnswers" which
			can then return a value of :

				, { "error" : "description of the error" }

			(including the leading bracket !)

			- this will get returned to the client, or to the build and alert that the client has errors, or that the build should terminate
		-->
	{
		<xsl:variable name="jsonPlaceholder">
			{
				"rcfPlaceHolder": "Please ignore",
				"ignoreNextAnswer": "y"
			}
		</xsl:variable>
		<xsl:variable name="nonSchemaDetectableErrors">
			<xsl:apply-templates mode="detectInvalidAnswers"/>
			<xsl:if test="$itemsFileName"><xsl:apply-templates select="document($itemsFileName)" mode="detectInvalidAnswers"/></xsl:if>
		</xsl:variable>

		"id": "<xsl:value-of select="@id"/>",

		<xsl:if test="$rcfVersion">
			"rcfVersion": "<xsl:value-of select="$rcfVersion"/>",
		</xsl:if>

		<xsl:if test="$nonSchemaDetectableErrors!=''">
		"errors": [
			<xsl:value-of select="$jsonPlaceholder"/>
			<xsl:value-of select="$nonSchemaDetectableErrors"/>
		],
		</xsl:if>

		<xsl:if test="$penaliseWrongAnswers='y'">
			"penaliseWrongAnswers": "y",
		</xsl:if>

		<xsl:if test="@overrideScore and @overrideScore > 0">
			<xsl:variable name="pointsMultiplier">
				<xsl:call-template name="getPointsMultiplier">
					<xsl:with-param name="activityNode" select="."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="pointsAvailable">
				<xsl:call-template name="activityPoints">
					<xsl:with-param name="activityNode" select="."/>
				</xsl:call-template>
			</xsl:variable>
			"pointsAvailable": "<xsl:value-of select="$pointsAvailable"/>",
			"overrideScore": "<xsl:value-of select="@overrideScore"/>",
			"pointsMultiplier": "<xsl:value-of select="$pointsMultiplier"/>",
		</xsl:if>

		"answers": [
			<xsl:value-of select="$jsonPlaceholder"/>
			<xsl:if test="$nonSchemaDetectableErrors=''">
				<xsl:apply-templates mode="outputAnswers"/>
				<!-- if any items then transform them too -->
				<xsl:if test="$itemsFileName">
					<xsl:apply-templates select="document($itemsFileName)" mode="outputAnswers"/>
				</xsl:if>
			</xsl:if>
		]
	}
	</xsl:template>

	<xsl:template name="outputAnswers">
		<xsl:apply-templates mode="outputAnswers"/>
	</xsl:template>

	<xsl:template name="maxScore" >
		<xsl:if test="@max_score">"max_score": <xsl:value-of select="@max_score"/>,</xsl:if>
	</xsl:template>

	<!-- ensure text nodes are ignored -->
	<xsl:template match="text()"/>

	<!-- ensure text nodes are ignored in 'outputAnswers' mode -->
	<xsl:template match="text()" mode="outputAnswers"/>

	<!-- ensure text nodes are ignored for the detectInvalidAnswers mode -->
	<xsl:template match="text()" mode="detectInvalidAnswers"/>

	<!-- templates to generate text 'hash' for sort / correct sort-order comparisons -->
	<xsl:template match="*" mode="orderHash"><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="orderHash"/><xsl:apply-templates mode="orderHash"/></xsl:template>

	<!-- templates to generate text 'hash' for sort / correct sort-order comparisons -->
	<xsl:template match="@*" mode="orderHash">.<xsl:value-of select="name()"/>.<xsl:value-of select="normalize-space(.)"/></xsl:template>

	<!-- templates to generate text 'hash' for sort / correct sort-order comparisons -->
	<xsl:template match="text()" mode="orderHash">
		<xsl:variable name="textValue"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="escapedValue">
			<xsl:call-template name="str:replace">
				<xsl:with-param name="string" select="$textValue"/>
				<xsl:with-param name="search"  select="'\'"/>
				<xsl:with-param name="replace" select="'\\'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$escapedValue"/></xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
