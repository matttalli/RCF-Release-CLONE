<?php

require_once("classes.php");
require_once("./php/lib.php");

if(isset($_GET["id"])) {
	$activityID = $_GET["id"];
} else {
	$activityID = "";
}

if(isset($_GET["mobile"])) {
	$mobile = $_GET["mobile"];
} else {
	$mobile = false;
}

if(isset($_GET["level"])) {
	$level = $_GET["level"];
} else {
	$level = "1";
}

if(isset($_GET['path'])) {
	$path = $_GET['path'];
	$pieces = explode('/', $path);
	$level = substr($pieces[0], 1);
}

$isMonoRepo = runningRcfMonoRepo();

// always force transformation cache to "y" for popup player
$_SESSION['useTransformCache'] = 'y';

// load the query params into session params as necessary
setUrlQueryParameters();

?>
<!doctype html>
<html class="<?php if ($isMonoRepo) { echo "rcf-monorepo"; } ?>">

	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
		<meta content="yes" name="apple-mobile-web-app-capable">

		<!-- PHP INCLUDE-->
		<script src="<?= RCF_URL ?>build/jslibs/jquery.min.js"></script>

		<link type="text/css" href="<?= RCF_URL ?>build/style/rcf_core.css" rel="stylesheet">

		<link type="text/css" href="<?= RCF_URL ?>build/style/rcf_768.css" media="only screen and (min-width: <?= MEDIAQUERY_768 ?>)" rel="stylesheet">
		<link type="text/css" href="<?= RCF_URL ?>build/style/rcf_1024.css" media="only screen and (min-width: <?= MEDIAQUERY_1024 ?>)"  rel="stylesheet">

<?php
if(defined('EXTERNAL_STYLES_NAME')) {
?>
		<link type="text/css" href="<?= EXTERNAL_ASSETS_FOLDER ?>/style/<?= EXTERNAL_STYLES_NAME ?>" rel="stylesheet">
		<link type="text/css" href="<?= EXTERNAL_ASSETS_FOLDER ?>/style/<?= EXTERNAL_STYLES_NAME_768 ?>" media="only screen and (min-width: <?= MEDIAQUERY_768 ?>)" rel="stylesheet">
		<link type="text/css" href="<?= EXTERNAL_ASSETS_FOLDER ?>/style/<?= EXTERNAL_STYLES_NAME_1024 ?>" media="only screen and (min-width: <?= MEDIAQUERY_1024 ?>)"  rel="stylesheet">
<?php
}
?>
		<link type="text/css" href="<?= CONTENT_URL ?>/project/shared/style/<?= PROJECT_CSS ?>" rel="stylesheet">
		<link type="text/css" href="<?= CONTENT_URL ?>/project/shared/style/<?= PROJECT_CSS_768 ?>" media="only screen and (min-width: <?= MEDIAQUERY_768 ?>)" rel="stylesheet">
		<link type="text/css" href="<?= CONTENT_URL ?>/project/shared/style/<?= PROJECT_CSS_1024 ?>" media="only screen and (min-width: <?= MEDIAQUERY_1024 ?>)"  rel="stylesheet">

		<link type="text/css" href="style/toastr.min.css" rel="stylesheet">
		<link type="text/css" href="style/animate.css" rel="stylesheet">

<!-- now the level css files -->
<!-- LEVELS css -->
		<!-- mobile first css ordering -->
		<link type="text/css" href="<?= CONTENT_URL ?>/project/products/Level_<?= $level ?>/assets/style/level.css" rel="stylesheet">
		<!-- 768 styles with media query -->
		<link type="text/css" href="<?= CONTENT_URL ?>/project/products/Level_<?= $level ?>/assets/style/level_768.css"  media="only screen and (min-width: <?= MEDIAQUERY_768 ?>)" rel="stylesheet">
		<!-- 1024 styles with media query -->
		<link type="text/css" href="<?= CONTENT_URL ?>/project/products/Level_<?= $level ?>/assets/style/level_1024.css"  media="only screen and (min-width: <?= MEDIAQUERY_1024 ?>)"  rel="stylesheet">

		<!-- output link to main RCF application script -->
		<!--
			JS Libraries
		-->
		<script type="text/javascript" src="<?= RCF_URL ?>build/js/rcf.min.js"></script>
    	<script type="text/javascript" src="<?= RCF_URL ?>build/js/rcf.libs.min.js"></script>


		<style>

			html.rcf-monorepo {
				background: url(./images/llama-bg.png) fixed no-repeat bottom right #e2d6e6;
			}

			html.rcf-monorepo body {
				background: transparent;
			}

			:root {
				--delay: 50ms;
			}

			main {
				height: 100vh;
				overflow-y: scroll;
			}

			.activityInstance {
				display: flex;
				flex-direction: column;
				flex: 1;
				margin-bottom: 75px;
			}

			.activityInstance[data-loaded=false]:after {
				content: " ";
				z-index: 10;
				display: block;
				position: absolute;
				height: 100%;
				top: 0;
				left: 0;
				right: 0;
				background: rgba(0, 0, 0, 0.5);
			}

			.section {
				position: relative;
				display: flex;
				flex-direction: column;
				padding-bottom: 5vh;
			}

			.section[data-template='item-based'] {
				min-height: 80vh;
			}


			.scoreCard {
				padding: 5px;
				border: 1px solid grey;
				background: white;
				color: black;
				text-align:center;
				border-radius: 5px;
			}


			.activityControls {
				background: #563d7c;
				display: flex;
				flex-direction: row;
				align-items: center;
				justify-content: center;
				position: fixed;
				bottom: 0;
				left: 0;
				right: 0;
				flex: 0;
				z-index: 100;
			}
			.activityControls button {
				height: 40px;
				margin: 15px;
			}

			.activityContainer {
				padding-bottom: 10px;
			}

			.showAnswers.answersButton,
			.nextAnswer.answersButton,
			.answersButton {
				display: inline-block;
				width: 31%;
			}

			.checkingAnswers:not(.perfectScore) .playerScore {
				animation: notPerfectScoreAnimation 0.5s;
			}

			.rcf-monorepo .playerToolbar button:disabled,
			.rcf-monorepo .playerToolbar button.answersButton:disabled,
			.answersButton:disabled {
				background: rgba(233,233,233,0.25);
				border-color: rgba(233,233,233,0.4);
			}

			.playerToolbar {
				position: fixed;
				bottom: 0;
				border-top: 1px solid #999;
				background: #aaa;
				width: 100%;

				display: flex;
				flex-direction: row;
				justify-content: flex-start;
				align-items: center;
				gap: 10px;
			}

			.rcf-monorepo .playerToolbar {
				background: #563d7c;
			}

			.playerToolbar .playerScore {
				margin: 5px;
				background: white;
				border: 1px solid #bbb;
				border-radius: 5px;
				padding: 3px 5px 0;
				height: 30px;
				min-width: 50px;
				text-align: center;
			}

			.playerToolbar .gradableTypeContainer {
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: center;
			}

			@media only screen and (max-width: 750px) {
				.playerToolbar .gradableTypeContainer {
					display: none;
				}
			}

			.playerToolbar .playerControls {
				flex: 1;
				display: flex;
				flex-direction: row;
				justify-content: center;
				align-items: center;
				gap: 15px;
			}

			.playerToolbar button {
				height: 35px;
				font-weight: bold;
				background-color: #497383;
				color: white;
				border-color: #497399;
				border-radius: 5px;
				max-width: max-content;
				vertical-align: top;
				margin: 5px 0;
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
			}
			.rcf-monorepo .playerToolbar button {
				background-color: #412d4e;
				font-weight: normal;
				border-color: #352d4e;
			}

			.playerToolbar .resetContainer {
				padding-right: 5px;
			}


			@keyframes notPerfectScoreAnimation {
				20%, 80% {
					transform: scale(0.8);
				}
				50% {
					transform: scale(1.1);
					background: red;
					color: white;
				}
				100% {
					background-color: auto;
					transform: scale(1);
				}
			}

			.checkingAnswers.perfectScore .playerScore {
				animation: perfectScoreAnimation 0.5s;
			}

			@keyframes perfectScoreAnimation {
				20%, 80% {
					transform: scale(0.8);
				}
				50% {
					transform: scale(1.1);
					background: green;
					color: white;
				}
				100% {
					background-color: auto;
					transform: scale(1);
				}
			}
		</style>
    </head>

    <body>
		<!--
			old layout :

			<div class="popupPlayer">
				<div id="contentContainer" class="rcfContentContainer activityContent">
					<div id="feedbackContainer" class="feedbackContainer">
						<h3>Activity complete !</h3>
					</div>
					<div id="rcfContent" class="rcfContentContainer activityContent desktop">

					</div>
				</div>

				<div class="playerToolbar">
					<div class="playerScore">
						<label class="scoreLabel">0</label>
					</div>
					<div class="gradableTypeContainer">
						<label class="gradableTypeText"></label>
					</div>
					<div class="playerControls">
						<select name="openGradableFeedbackOptions" id="openGradableFeedbackOptions" class="actControls viewerSingleButton openGradableFeedbackOptions" title="open-gradable feedback mode">
							<option value="default" selected>Default</option>
							<option value="leaveTeacherFeedback">Leave teacher feedback</option>
							<option value="reviewTeacherFeedback">Review teacher feedback</option>
							<option value="answerKeyMode">Answer Key Mode</option>
						</select>
						<button class="showAnswers answersButton">Show answers</button>
						<button class="nextAnswer answersButton">Next answer</button>
						<button class="checkAnswers answersButton">Check answers</button>
						<button class="tryAgain answersButton">Try again</button>
					</div>
					<div class="resetContainer">
						<button class="reset">Reset</button>
					</div>
				</div>
			</div>
			<div class="popupPlayerError">
				<div class="errorMessage"/>
			</div>

		-->
		<div class="popupPlayer">
			<div id="contentContainer" class="rcfContentContainer activityContent">
				<!--
					hide instant feedback stuff for now ...

				<div id="feedbackContainer" class="feedbackContainer">
					<h3>Activity complete !</h3>
				</div>
				-->
				<!-- populated by the solidjs multiple activities player code -->
				<div id="app"></div>
			</div>

		</div>

		<!--
			hide for now - until we know what we want to do with the errors

		<div class="popupPlayerError">
			<div class="errorMessage"></div>
		</div>

		-->


		<script src="compiled/rcfPopupPlayer/rcfPopupPlayer.min.js"></script>

    </body>
</html>
