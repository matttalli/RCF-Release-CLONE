<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!--
		*******************************************************************************************
			page includes
		*******************************************************************************************
	-->
	<!-- handle page scoring / determination -->
	<xsl:include href="./scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl" />
	<!-- handle activity mode calculation -->
	<xsl:include href="./activityModeCalculation/inc_rcf_activity_mode_calculation.xsl" />

	<!-- *******************************************************************************************
			include standard / generic items
		 ******************************************************************************************* -->
	<!-- utils -->
	<xsl:include href="./inc_utils.xsl"/>
	<xsl:include href="./interactions/utils/inc_html_classes_utils.xsl"/>
	<xsl:include href="./interactions/utils/inc_rcf_typein-utils.xsl"/>
	<xsl:include href="./interactions/utils/inc_svg_path_utils.xsl"/>
	<xsl:include href="./interactions/utils/inc_validate_listen_and_colour_svg.xsl"/>
	<xsl:include href="./interactions/utils/inc_validate_find_in_image_svg.xsl"/>

	<!-- Activity Element -->
	<xsl:include href="./activity/inc_rcf_activity.xsl"/>

	<!-- determine the interactions to use ... -->
	<xsl:include href="./interactions/inc_determineInteractions.xsl"/>

	<!-- rubric element -->
	<xsl:include href="./rubric/inc_rcf_rubric.xsl"/>
	<!-- multimedia elements -->
	<xsl:include href="./interactions/audio/inc_rcf_audio.xsl"/>
	<xsl:include href="./interactions/video/inc_rcf_video.xsl"/>

	<!-- wordBox output for droppables -->
	<xsl:include href="./wordbox/inc_rcf_wordbox.xsl" />
	<xsl:include href="./wordbox/inc_rcf_wordbox_collapsible_controls.xsl"/>

	<!-- unmarked / layout interactions with js code -->
	<xsl:include href="./interactions/chase/inc_rcf_chase.xsl"/>
	<xsl:include href="./interactions/splitBlock/inc_rcf_splitblock.xsl"/>
	<xsl:include href="./interactions/carousel/inc_rcf_carousel.xsl"/>
	<xsl:include href="./interactions/carousel/inc_rcf_simplecarousel.xsl"/>

	<!-- block level elements for layout -->
	<!-- markup items -->
	<xsl:include href="./mediaElement/inc_rcf_media_element.xsl"/>
	<xsl:include href="./markup/blockElements/inc_rcf_block_elements.xsl"/>
	<xsl:include href="./markup/inc_rcf_markup.xsl" />
	<xsl:include href="./markup/blockElements/staticAudioTranscript/inc_static_audio_transcript.xsl"/>
	<xsl:include href="./markup/blockElements/staticWordPool/inc_rcf_staticWordPool.xsl"/>
	<xsl:include href="./markup/blockElements/presentation/inc_rcf_presentation.xsl"/>
	<xsl:include href="./markup/blockElements/interactive/inc_rcf_interactive.xsl"/>

	<xsl:include href="./main/inc_rcf_main.xsl"/>
	<xsl:include href="./inc_rcf_url_utils.xsl"/>

	<!-- metadata elements ... ignored for now -->
	<xsl:include href="./metadata/inc_rcf_metadata.xsl"/>

	<!-- 'canDo' elements -->
	<xsl:include href="./interactions/canDo/inc_rcf_cando.xsl"/>
	<!-- 'interactive text' blocks - chase etc -->
	<xsl:include href="./interactions/interactiveText/inc_rcf_interactive_text.xsl" />

	<!-- *******************************************************************************************
			handle markable interaction items
		 ******************************************************************************************* -->
	<xsl:include href="./interactions/categorise/inc_rcf_categorise.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_hybrid.xsl"/>
	<xsl:include href="./interactions/categorise/radioTable/inc_rcf_categorise_radiotable.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_radiolist.xsl"/>
	<xsl:include href="./interactions/categorise/dropdown/inc_rcf_categorise_dropdown.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_itemselect.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_complex_hybrid.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_complex_checkboxlist.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_complex_itemselect.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_complex_checkboxtable.xsl"/>
	<xsl:include href="./interactions/categorise/inc_rcf_categorise_wordbox.xsl"/>
	<xsl:include href="./interactions/radiolist/inc_rcf_radiolist.xsl"/>
	<xsl:include href="./interactions/radiolist/inc_rcf_radiolist_itemselect.xsl"/>
	<xsl:include href="./interactions/itembased/itemRadio/inc_rcf_itemradiolist.xsl"/>
	<xsl:include href="./interactions/itembased/itemRadio/inc_rcf_itemradiolist_itemselect.xsl"/>
	<xsl:include href="./interactions/itembased/itemCheckbox/inc_rcf_itemcheckbox.xsl"/>
	<xsl:include href="./interactions/itembased/itemCheckbox/inc_rcf_itemcheckbox_itemselect.xsl"/>
	<xsl:include href="./interactions/itembased/itemSelectableText/inc_rcf_itemselectabletext.xsl"/>
	<xsl:include href="./interactions/itembased/itemComplexDroppableBlock/inc_rcf_itemcomplexdroppable_block.xsl"/>
	<xsl:include href="./interactions/itembased/itemSentenceBuilder/inc_rcf_itemsentencebuilder.xsl"/>
	<xsl:include href="./interactions/checkbox/inc_rcf_checkbox.xsl"/>
	<xsl:include href="./interactions/checkbox/inc_rcf_checkbox_itemselect.xsl"/>

	<xsl:include href="./interactions/locating/inc_rcf_locating.xsl" />
	<xsl:include href="./interactions/droppable/inc_rcf_droppable.xsl" />
	<xsl:include href="./interactions/complexDroppable/inc_rcf_complexdroppable.xsl" />
	<xsl:include href="./interactions/dropdown/inc_rcf_dropdown.xsl" />

	<xsl:include href="./interactions/textInputs/inc_rcf_typein.xsl" />
	<xsl:include href="./interactions/textInputs/inc_rcf_ml_typein.xsl" />
	<xsl:include href="./interactions/textInputs/inc_rcf_typein_group.xsl" />
	<xsl:include href="./interactions/textInputs/inc_rcf_text_input.xsl" />
	<xsl:include href="./interactions/textInputs/inc_rcf_ml_text_input.xsl" />

	<xsl:include href="./interactions/blendedFlashcards/inc_rcf_blendedFlashcards.xsl"/>
	<xsl:include href="./interactions/listenAndColour/inc_rcf_listen_and_colour.xsl"/>
	<xsl:include href="./interactions/balloons/inc_rcf_balloons.xsl"/>

	<!-- vendors games -->

	<!-- fish in a bottle 'bubbles based' games -->
	<xsl:include href="./interactions/vendorGames/inc_vendor_games.xsl"/>

	<xsl:include href="./interactions/story/inc_rcf_story.xsl"/>
	<xsl:include href="./interactions/sentenceBuilder/inc_rcf_sentence_builder.xsl"/>
	<xsl:include href="./interactions/wordInsert/inc_rcf_wordinsert.xsl"/>
	<xsl:include href="./interactions/findInImage/inc_rcf_find_in_image.xsl"/>
	<xsl:include href="./interactions/orderingInteractions/inc_rcf_ordering_interactions.xsl"/>
	<xsl:include href="./interactions/wordsearch/inc_rcf_wordsearch.xsl"/>
	<xsl:include href="./interactions/wordsearch/inc_rcf_fixed_wordsearch.xsl"/>
	<xsl:include href="./interactions/wordSnake/inc_rcf_wordsnake.xsl"/>
	<xsl:include href="./interactions/crossword/inc_rcf_crossword.xsl"/>
	<xsl:include href="./interactions/fixedCrossword/inc_rcf_fixed_crossword.xsl"/>
	<xsl:include href="./interactions/matching/inc_rcf_matching.xsl"/>
	<xsl:include href="./interactions/pelmanism/inc_rcf_pelmanism.xsl"/>
	<xsl:include href="./interactions/hangman/inc_rcf_hangman.xsl"/>
	<xsl:include href="./interactions/verticalCrossword/inc_rcf_verticalcrossword.xsl"/>
	<xsl:include href="./interactions/interactiveImage/inc_rcf_interactiveimage.xsl"/>
	<xsl:include href="./interactions/flashcard/inc_rcf_flashcard.xsl"/>
	<xsl:include href="./interactions/movingTargets/inc_rcf_moving_targets.xsl"/>
	<xsl:include href="./interactions/compositeScene/inc_rcf_composite_scene.xsl"/>
	<xsl:include href="./interactions/colouring/inc_rcf_colouring.xsl"/>
	<xsl:include href="./interactions/writing/inc_rcf_writing.xsl"/>
	<xsl:include href="./interactions/teacherGradedTask/inc_rcf_teacherGradedTask.xsl"/>
	<xsl:include href="./interactions/freeDrawing/inc_rcf_freeDrawing.xsl"/>

	<xsl:include href="./interactions/recording/inc_rcf_recording.xsl"/>
	<xsl:include href="./interactions/answerkey/inc_rcf_answerkey.xsl"/>
	<xsl:include href="./interactions/tileMaze/categorise/inc_rcf_categoriseTileMaze.xsl"/>
	<xsl:include href="./interactions/tileMaze/sequence/inc_rcf_sequenceTileMaze.xsl"/>

	<xsl:include href="./interactions/overallScore/inc_rcf_overallScore.xsl"/>

	<!-- item based includes -->
	<xsl:include href="./interactions/itembased/inc_rcf_itembased.xsl"/>
	<xsl:include href="./interactions/itembased/typein/inc_rcf_itemtypein.xsl"/>
	<xsl:include href="./interactions/itembased/itemTypeinGroup/inc_rcf_itemtypeingroup.xsl"/>
	<xsl:include href="./interactions/itembased/itemWordInsert/inc_rcf_itemwordinsert.xsl"/>

	<!-- maths interactions -->
	<xsl:include href="./interactions/math/addition/inc_rcf_addition.xsl"/>
	<xsl:include href="./interactions/math/subtraction/inc_rcf_subtraction.xsl"/>
	<xsl:include href="./interactions/math/multiplication/inc_rcf_multiplication.xsl"/>
	<xsl:include href="./interactions/math/division/inc_rcf_division.xsl"/>

	<!-- cover screens -->
	<xsl:include href="./interactions/coverScreen/inc_rcf_cover_screen.xsl"/>

	<!-- svgs for audio player / recording -->
	<xsl:include href="./interactions/audio/inc_rcf_audioImages.xsl"/>

	<!-- template rules to detect invalid combinations which can't be handled in the schema -->
	<xsl:include href="./markup/inc_rcf_detect_invalid_combinations.xsl"/>

</xsl:stylesheet>
