<?php
	include "head.php";

	// determine if rcf is running as a monorepo from the package.json file
	if(runningRcfMonorepo()) {
		// add class the html element - picked up by the viewer later
		$monoRepoClass = 'rcf-monorepo';
	} else {
		$monoRepoClass = '';
	}

	/* if flushing the cache (from rcf-source-monorepo) then show the 'loading' div */
	$loadingClass = "";
	if($flush) {
		$loadingClass = "loadingProjectStructure";
	}

?>
<!doctype html>
<html
	xmlns:ng="http://angularjs.org"
	data-rcf-monorepo="<?php echo $monoRepoClass ?>"
	class="<?php echo $monoRepoClass . " " . $loadingClass ?>"
	ng-class="{'zenMode': layout.zenMode}"
	id="ng-app"
	ng-controller="PageController"
	ng-init="init()"
>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

		<title ng-bind="pageTitle"></title>

		<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
		<meta content="yes" name="apple-mobile-web-app-capable">
		<!-- must run this before angular etc are included -->
		<script type="text/javascript">
			window.rootAppLocation = '<?php echo CONTENT_URL ?>/project/products';
			window.levelAssetsUrl = '<?php echo LEVEL_ASSETS_URL ?>';
		</script>
		<!-- PHP INCLUDE-->
		<?php include "header.php" ?>
		<!-- php INCLUDE END... -->

		<!-- LEVELS css -->
		<!-- mobile first css ordering -->
		<link ng-if="!!currentLevel" type="text/css" ng-href="{{levelAssetsUrl}}/Level_{{currentLevel}}/assets/style/level.css" rel="stylesheet"/>
		<!-- 768 styles with media query -->
		<link ng-if="!!currentLevel" type="text/css" ng-href="{{levelAssetsUrl}}/Level_{{currentLevel}}/assets/style/level_768.css"  media="only screen and (min-width: <?php echo MEDIAQUERY_768 ?>)" rel="stylesheet"/>
		<!-- 1024 styles with media query -->
		<link ng-if="!!currentLevel" type="text/css" ng-href="{{levelAssetsUrl}}/Level_{{currentLevel}}/assets/style/level_1024.css"  media="only screen and (min-width: <?php echo MEDIAQUERY_1024 ?>)"  rel="stylesheet"/>

		<style>

			.loadingToc .viewer-container {
				pointer-events: none;
			}

			/* .loadingToc .crumb a:last-child:after { */
			.loadingToc .crumb a:last-child:after {
				content: "\00a0\00a0\00a0\00a0\00a0\00a0";
				min-width: 50px;
				background:
					url('./images/ajax-loader.gif')
					50% 50%
					no-repeat;
			}

			.loadingProjectStructure .viewer-container {
				display: none;
			}

			.viewerLoader {
				display: none;
			}

			.loadingProjectStructure .viewerLoader {
				display: flex;
				flex-direction: column;
				flex-wrap: nowrap;
				justify-content: center;
				align-items: center;
				min-height: 99vh;
			}
			.sideBar {
				flex: auto;
				min-width: 60px;
				max-width: 60px;
				background: var(--dark-bar-3);
				flex: 0;
				display: flex;
				flex-direction: column;
				align-items: center;
			}
			.sideBar ul  {
			}
			.sideBar ul li {
				padding-bottom: 15px;
			}

			.sideBar button,
			.nav button {
				min-width: 50px;
				background: transparent;
				border: none;
				outline: none;
				color: rgba(255,255,255,0.6);
				width: 100%;
				padding-top: 10px;
				padding-bottom: 10px;
			}
			.sideBar button span {
				font-size: 10px;
			}
			.sideBar button:hover,
			.nav button:hover,
			.sideBar button.selected,
			.nav button.selected {
				color: rgba(255,255,255,1);
				background: var(--selection-background);
				cursor: pointer;
			}

			.sideBar svg,
			.nav svg {
				max-width: 30px;
			}

			.navArrowButtons {
				white-space: nowrap;
			}

			@media only screen and (min-width: 200px) and (max-width: 768px) {
				.sideBar {
					display: none;
				}

				.nav .logo {
					display: none;
				}

				.tocPanel.tocOpen {
					min-width: 180px;
				}

				nav.crumb .breadcrumbs__item {
					font-size: 0.7em;
					white-space: nowrap;
				}

				.toc li a {
					font-size: 10px;
				}
				.expandButton {
					background: rgba(200,200,200,0.5);
				}
				.activityToolbar .spacer {
					display: none;
				}

			}

			@media only screen and (min-width: 200px) and (max-width: 768px) and (orientation: landscape) {
				.sideBar {
					display: flex;
				}
			}

		</style>
	</head>


	<body ng-class="{ 'desktopViewerMode' : layout.isDesktopMode, 'mobileViewerMode': !layout.isDesktopMode, 'loadingToc': loadingTocCount !== 0 }">
		<div class="viewerLoader">
			<h1>Loading project ... please wait ... <span class="loading">&nbsp;&nbsp;&nbsp;&nbsp;</span></h1>
		</div>
		<div class="viewer-container">
			<!-- toolbar -->
			<rcf-toolbar></rcf-toolbar>
			<!-- nav panel -->
			<div class="nav">
				<rcf-breadcrumbs ></rcf-breadcrumbs>
				<span class="logo" >
					<span ng-click="resetCache()" ng-show="!!projectType">Project type '{{projectType}}', RCF Version {{RCFVersion}}</span>
				</span>
			</div>

			<div class="mainViewerContent">
				<rcf-viewer-sidebar></rcf-viewer-sidebar>
				<!-- toc panel -->
				<rcf-toc></rcf-toc>

				<!-- container div -->
				<div class="panelsContainer" ng-class="{'editPanelOpen': layout.showEditor, 'splitView': layout.splitView, 'tocOpen': layout.showTOCPanel } ">
					<div ng-click="layout.showTOCPanel = !layout.showTOCPanel" class="expandButton">
						<span ng-show="layout.showTOCPanel">&#9664;</span>
						<span ng-show="!layout.showTOCPanel">&#9654;</span>
					</div>
					<!-- edit Panel -->
					<div class="editPanelContainer" ng-include="'partials/editPanel.html'"></div>
					<!-- activity content -->
					<ng-view ng-show="!layout.editorFullScreen"></ng-view>
				</div>
			</div>

			<rcf-score-card></rcf-score-card>
		</div>

		<!-- viewer mask -->
		<div class="viewerMask" id="viewerMask" ng-show="loadingInvalidActivities">&nbsp;</div>

		<!-- load the webpack compiled viewer -->
		<script src="compiled/viewer/viewer.min.js?<?php echo uniqid() ?>"></script>

	</body>
</html>
