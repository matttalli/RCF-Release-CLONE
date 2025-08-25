<?php
require("php/lib.php");
require("php/includes.php");

$isRunningAsMonoRepo = runningRcfMonorepo();

$pathToProduction = $isRunningAsMonoRepo ? '../' : '../..';
$pathToRcfFiles = $isRunningAsMonoRepo ? '../dist/rcf-release' : '..';

?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Multiple Activities Test Harness</title>

		<link rel="stylesheet" href="<?= $pathToRcfFiles ?>/build/style/rcf_core.css">

		<link href="<?= $pathToRcfFiles ?>/build/style/rcf_core.css" rel="stylesheet">

		<!-- 3rd party libraries - these are concatenated into rcf_core.css during the build of the product/project -->
		<link href="<?= $pathToRcfFiles ?>/build/style/rcf_768.css" media="only screen and (min-width: 768px)" rel="stylesheet">
		<link href="<?= $pathToRcfFiles ?>/build/style/rcf_1024.css" media="only screen and (min-width: 1425px)" rel="stylesheet">

		<link href="<?= $pathToProduction ?>/production/project/shared/style/<?= PROJECT_CSS ?>" rel="stylesheet">
		<link href="<?= $pathToProduction ?>/production/project/shared/style/<?= PROJECT_CSS_768 ?>" media="only screen and (min-width: 768px)"  rel="stylesheet">
		<link href="<?= $pathToProduction ?>/production/project/shared/style/<?= PROJECT_CSS_1024 ?>" media="only screen and (min-width: 1425px)"  rel="stylesheet">

		<script src="<?= $pathToRcfFiles ?>/build/jslibs/jquery.min.js"></script>
		<script  src="<?= $pathToRcfFiles ?>/build/js/rcf.min.js"></script>

		<style>
			:root {
				--delay: 50ms;
			}

			main {
				/* scroll-snap-type: y mandatory; */
				scroll-snap-type: y proximity;
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

			.changeFontSize {
				position: absolute;
				right: 10px;
				top: 10px;
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: flex-end;
				gap: 10px;
				z-index: 1;
			}
			.changeFontSize.menuShown .changeFontSizeMenu {
				display: flex;
				gap: 5px;
				background-color: #ffffffdd;
				border-radius: 5px;
				padding: 5px;
			}
			.changeFontSize.menuHidden .changeFontSizeMenu {
				display: none;
			}
			.activity.small {
				font-size: calc(16px * 0.75);
			}
			.activity.medium {
				font-size: 16px;
			}
			.activity.large {
				font-size: calc(16px * 1.5);
			}
			.activity.extraLarge {
				font-size: calc(16px * 2);
			}

			.section {
				position: relative;
				scroll-snap-align: start;
				display: flex;
				flex-direction: column;
				padding-bottom: 5vh;
			}

			.section[data-template='item-based'] {
				min-height: 80vh;
			}

			.section:nth-child(odd),
			.section:nth-child(odd) .activityControls	 {
				background-color: purple;
			}

			.section:nth-child(even),
			.section:nth-child(even) .activityControls {
				background-color: pink;
			}

			.scoreCard {
				padding: 10px;
				border: 1px solid grey;
				background: hsl(300deg 100% 38%);
				color: white;
				text-align:center;
			}


			.activityControls {
				display: flex;
				flex-direction: row;
				align-items: center;
				justify-content: center;
				position: sticky;
				bottom: 0;
				left: 0;
				right: 0;
				flex: 0;
			}
			.activityControls button {
				height: 40px;
				margin: 15px;
			}


			.activity {
				margin-top: 50px;
				border-radius: 10px;
				border: none;
				box-shadow: 3px 6px 15px 0px rgb(0 0 0 / 75%);
			}

			.activityContainer {
				padding-bottom: 10px;
			}

			.checkingAnswers:not(.perfectScore) .playerScore {
				animation: notPerfectScoreAnimation 0.5s;
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
		<main id="app"></main>

		<script src="compiled/rcfMultipleActivitiesPlayer/rcfMultipleActivitiesPlayer.min.js"></script>

	</body>

</html>
