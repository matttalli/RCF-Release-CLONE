<?php

$app->get("/project", function() use($app) {
	//
	$app->response()->header("Content-Type", "application/json");
	//
	$results = array(
		"projectName" => CDN_PROJECT_NAME,
		"projectVersion" => CDN_PROJECT_VERSION,
		"projectType" => PROJECT_TYPE,
		"mobileDragDrop" => ( isset($_SESSION['mobileDragDrop']) ? $_SESSION['mobileDragDrop'] : MOBILE_DRAGDROP ),
		"wordPoolPosition" => ( isset($_SESSION['wordBoxPosition']) ? $_SESSION['wordBoxPosition'] : WORDBOX_POSITION ),
		"dropDownListOutput" => ( isset($_SESSION['dropDownListOutput']) ? $_SESSION['dropDownListOutput'] : DROPDOWN_LIST_OUTPUT ),
		"stickyWordPools" =>( isset($_SESSION['stickyWordPools']) ? $_SESSION['stickyWordPools'] : STICKY_WORDPOOLS ),
		"fixedWordPools" =>( isset($_SESSION['fixedWordPools']) ? $_SESSION['fixedWordPools'] : FIXED_WORDPOOLS ),
		"collapsibleWordPools" => ( isset($_SESSION['collapsibleWordBox']) ? $_SESSION['collapsibleWordBox'] : COLLAPSIBLE_WORDBOX ),
		"penaliseWrongAnswers" => ( isset($_SESSION['penaliseWrongAnswers']) ? $_SESSION['penaliseWrongAnswers'] : PENALISE_WRONG_ANSWERS ),
		"disableOpenGradableTeacherComments" => ( isset($_SESSION['disableOpenGradableTeacherComments']) ? $_SESSION['disableOpenGradableTeacherComments'] : DISABLE_OPENGRADABLE_TEACHER_COMMENTS)
	);
	//
	$jsonResults = json_encode($results);
	//
	$app->response()->setBody($jsonResults);
});
?>
