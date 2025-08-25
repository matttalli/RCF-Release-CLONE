<?php
require_once("includes.php");
require_once("manifestUtils.php");
/*
Returns a manifest for the rcf-player / adapter to consume

	NOTE !

	The activity and activity desktop styles are injected straight into the HTML and NOT provided
	in the 'css' section of the manifest

	This is because the viewer and popup player do not support the injected css styles (too much work to implement them and requires fighting against angular :( )

	It still works *identically* to the rcf-player method of injecting the styles (even generates the same media query)

*/
$app->get("/manifest/activitySet/:path+", function($path) use($app) {

	// allow cors
	$app->response()->header("Access-Control-Allow-Origin", "*");

	// return json
	$app->response()->header("Content-Type", "application/json");

	// get the supplied path (L01/U01/S01/A01 etc) into an array split by '/'
	$path = implode("/", $path);

	// get the path on the server from that supplied path
	$serverPath = getServerPathFromAngularPath($path);

	// determine if the path points to an activity set or an activity
	$isActivityPath = preg_match("/A(\d\d)([a-zA-Z]{1})?$/", $path);

	$activityPath = "";

	// the the activity set id to the supplied path (doesn't matter if it's not a real activity set !)
	$activitySetId = $path;

	// if the path points to an activity, then get the server path for that activity parent folder
	if($isActivityPath) {
		$activityPath = $path;
		$serverPath = dirname($serverPath);
	}

	// get the level name from the server path
	$level = getLevelFromFileName($serverPath);

	// build the media queries
	$mqDesktop = "only screen and (min-width: " . MEDIAQUERY_768 . ")";
	$mqLargeDesktop = "only screen and (min-width: " . MEDIAQUERY_1024 . ")";


	// RCF-9946 - figure out the path build to use - either monorepo or project
	$rcfRootBuildPath = (realpath(RCF_PATH . 'dist/rcf-release')) ? 'dist/rcf-release/build' : 'build';

	// build the rcf versions part of the manifest
	$rcfVersions = (object) [
		RCF_VERSION => (object) [
			"isActivityPath" => $isActivityPath,
			"activityPath" => $activityPath,

			"rootPath" => $rcfRootBuildPath,

			"scripts" => [
				"js/rcf.min.js"
			],

			"css" => [
				(object) [
					"path" => "style-min/rcf_core.min.css"
				],
				(object) [
					"path" => "style-min/rcf_desktop.min.css",
					"mediaQuery" => $mqDesktop
				],
				(object) [
					"path" => "style-min/rcf_large_desktop.min.css",
					"mediaQuery" => $mqLargeDesktop
				]
			],
			"version" => RCF_VERSION
		]
	];


	// read the metadata file for the activity set to get the activity set title
	$metaDataObject = new MetaData("{$serverPath}/metadata.xml");
	$metadata = json_decode($metaDataObject->getJSON());
	$activitySetTitle = $metadata->title;

	// get the activity set folder object so that we can read all the activities inside it
	$activitySetFolder = new ProductionFolder($serverPath);
	$activities = json_decode( $activitySetFolder->getJSON()) ;

	// used to hold the ids of the activities in the activitySet
	$activityIds = array();

	// activities for the manifest
	$manifestActivities = (object) [] ;

	// used to hold activity modes for the activity set
	$activityModes = array();

	// determine the paths to use for the project - this is setup in the includes.php and accounts for rcf as monorepo settings
	$projectAssetsPath = PROJECT_PATH . "production/project/shared/style/";
	$manifestLevelAssetsPath = LEVEL_ASSETS_URL . "/{$level}/assets/style/";

	// loop through all the activities in the activity set - if we are only interested in one activity then look for that one !
	foreach($activities as $activity) {
		if(!$isActivityPath || ( $isActivityPath && $activity->location === $activityPath)) {
			// add the current activity to the activity set list of activities for the manifest
			$activityIds[] = $activity->xmlID;
			$activityLocation = $activity->location;

			// build the server path for the activity
			$activityServerPath = getServerPathFromAngularPath($activity->location);
			$activityServerPath .= "/{$activity->fileName}";

			// load the activity object
			$activityObject = new Activity($activityServerPath);
			// get all the information for the activity (html, json, etc)
			$activityJSON = json_decode($activityObject->getAsJSON("n"));

			// base-64 encode the html and json so that we don't have to worry about escaping certain characters etc
			$html = base64_encode($activityJSON->{"htmlContent"});
			$json = base64_encode($activityJSON->{"jsonContent"});


			$activityModes[] = str_ireplace(" ", ",", $activityJSON->{"activityMode"});

			// build the manifest activity for the current activity
			$manifestActivities->{$activity->xmlID} = (object) [
				"activityId" => $activity->xmlID,
				"gradableType" => $activityJSON->{"gradable"},
				"pointsAvailable" => $activityJSON->{"pointsAvailable"},
				"teacherPointsAvailable" => $activityJSON->{"teacherPoints"},
				"minWidthMobile" => MEDIAQUERY_768,
				"rcfVersion" => RCF_VERSION,
				"rootPath" => "viewer", // because we are loading api.php calls from here - and it matches the requirements for the PROJECT_PATH php constant elsewhere in the viewer

				"css" => [
					// css entries now added conditionally depending on whether the files exist in the underlying file system
				],
				"html" => "data:text/html;base64,{$html}",
				"json" => "data:application/json;base64,{$json}",
				"hasItems" => $activityObject->hasItems()
			];

			// external styles first
			if (defined('EXTERNAL_STYLES_NAME')) {
				$sharedAssetsUrl = EXTERNAL_ASSETS_FOLDER . '/style/';
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $sharedAssetsUrl . EXTERNAL_STYLES_NAME
				]);

				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $sharedAssetsUrl . EXTERNAL_STYLES_NAME_768,
					"mediaQuery" => $mqDesktop
				]);

				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $sharedAssetsUrl . EXTERNAL_STYLES_NAME_1024,
					"mediaQuery" => $mqLargeDesktop
				]);
			}

			// then project css
			if(file_exists($projectAssetsPath . PROJECT_CSS)) {
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $projectAssetsPath . PROJECT_CSS
				]);
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $projectAssetsPath . PROJECT_CSS_768,
					"mediaQuery" => $mqDesktop
				]);
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $projectAssetsPath . PROJECT_CSS_1024,
					"mediaQuery" => $mqLargeDesktop
				]);
			}

			// then level css
			if(file_exists($manifestLevelAssetsPath . "level.css")) {
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $manifestLevelAssetsPath . "level.css"
				]);
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $manifestLevelAssetsPath . "level_768.css",
					"mediaQuery" => $mqDesktop
				]);
				array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
					"path" => $manifestLevelAssetsPath . "level_1024.css",
					"mediaQuery" => $mqLargeDesktop
				]);
			}

			// finally add the activity css
			array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
				"path" => str_replace(".xml", ".css", $activityServerPath)
			]);
			array_push($manifestActivities->{$activity->xmlID}->{"css"}, (object) [
				"path" => str_replace(".xml", "_768.css", $activityServerPath),
				"mediaQuery" => $mqDesktop
			]);

			// add the 'itemSets' if it is an item based activity
			if($activityObject->hasItems()) {
				$manifestActivities->{$activity->xmlID}->itemSets = $activityObject->getItemSets();
			}

		}
	}

	$activitySets = (object) [
		$activitySetId => (object) [
			"activitySetId" => $activitySetId,
			"title" => $activitySetTitle,
			"activityMode" => explode(',', $activityModes[0])[0], //implode(',', $activityModes),
			"activities" => $activityIds
		]
	];

	$manifestForBrowser = (object) [
		"rcfVersions" => $rcfVersions,
		"activitySets" => $activitySets,
		"activities" => $manifestActivities
	];

	$app->response()->setBody(json_encode($manifestForBrowser, JSON_UNESCAPED_SLASHES));
});

// new route for the playlist manifest - for the viewer, the playlist id is just a viewer path, eg L10/U01/S01 etc
$app->get("/manifest/playlist/:id+", function($id) use ($app) {

	// allow cors
	$app->response()->header("Access-Control-Allow-Origin", "*");

	// return json
	$app->response()->header("Content-Type", "application/json");

	// use the provided playlist $id as a viewer path
	$path = $id;

	// if the $id contains a ',' then extract all the $paths from the $id
	// if $id is an array then explode it to multiple paths
	// otherwise just use the $id as a single path

	// if(strpos($id, ",") !== false) {
	if(is_array($id)) {
		$path = implode("/", $id);
		$paths = explode(",", $path);
		// print_r($paths);
	} else {
		$paths = array($id);
	}

	// determine if we are using external styles (global styles)
	$usingGlobalStyles = defined('EXTERNAL_STYLES_NAME'); // global styles ....

	$serverActivities = [];

	// loop through each $path in the $paths
	foreach ($paths as $singlePath) {
		// get the path on the server from that supplied path
		$rootPlaylistPath = getServerPathFromAngularPath($singlePath);

		// append the getPlaylistArray results to the $serverActivities array
		$serverActivities = array_merge($serverActivities, getPlayListArray($rootPlaylistPath));
	}
	// should really sort them here
	usort($serverActivities, "activitySort");

	// our playlist manifest objects
	$manifestActivities = [];
	$manifestActivitySets = [];
	$manifestLessons = [];
	$manifestSections = [];
	$manifestRcfVersions = [];
	$manifestReferenceContents = [];
	$manifestGlobalStyles = [];

	$processedActivitySets = (object) [];
	$processedLessons = (object) [];
	$processedSections = (object) [];


	foreach($serverActivities as $serverActivityPath) {
		// get the server file path for each activity path
		$serverPath = getServerPathFromAngularPath($serverActivityPath);

		// get the transformed activity for the manifest
		$activity = getActivityForManifest($serverPath);

		// add the activity to the playlist manifest 'activities' object
		$manifestActivities[] = $activity;

		// get the activity set the activity belongs to
		$activitySetPath = getActivitySetPathFromServerPath($serverPath);

		// get the activity set for the playlist manifest
		$activitySet = getActivitySetForManifest($activitySetPath);
		if(!isset($processedActivitySets->{ $activitySetPath })) {
			$manifestActivitySets[] = $activitySet;
			$processedActivitySets->{ $activitySetPath } = true;
		}

		$activitySetMode = "";

		foreach($activitySet->activities as $activityId) {
			// get the activity for the activity set
			$activitySetMode .= $activity->{"activityMode"} . ",";
		}

		// trim the last ',' character from the $activitySetMode string
		$activitySetMode = rtrim($activitySetMode, ",");
		$activitySet->activityMode = $activitySetMode;

		// loop through the $activitySet->activities array

		// get the lesson for the activity
		$lessonPath = getLessonPathFromServerPath($serverPath);

		// if we have a lesson path then get the lesson for the playlist manifest
		if(!empty($lessonPath)) {
			if(!isset($processedLessons->{ $lessonPath })) {
				$lesson = getLessonForManifest($lessonPath);
				// add to the $manifestLessons array
				$manifestLessons[] = $lesson;
				$processedLessons->{ $lessonPath } = true;
			}
		}

		// get the section for the activity
		$sectionPath = getSectionPathFromServerPath($serverPath);

		// if we have a section path then get the section for the playlist manifest
		if(!empty($sectionPath)) {
			if(!isset($processedSections->{ $sectionPath })) {
				$section = getSectionForManifest($sectionPath);
				$manifestSections[] = $section;
				$processedSections->{ $sectionPath } = true;
			}
		}

	}

	// loop through all the keyed objects in the $manifestActivities object
	foreach($manifestActivities as $activity) {
		// check if the $activity has a referenceContentIds property
		if(property_exists($activity, "referenceContentIds")) {
			// loop through each referenceContentId
			foreach($activity->referenceContentIds as $referenceContentId) {
				if($referenceContentId === "") {
					continue;
				}
				$referenceContent = getReferenceContentForManifest($referenceContentId);
				$manifestReferenceContents[] = $referenceContent;
			}
		}
	}

	// join all the $lesson->{ $lesson->id }->activities into a single array
	$lessonActivities = array();
	foreach($manifestLessons as $lesson) {
		if(property_exists($lesson, "activities")) {
			$lessonActivities = array_merge($lessonActivities, $lesson->activities);
		}
	}

	// loop through each $lesson->{ $lesson->id }->activitySets entry and delete it if it doesn't exist in the $manifestActivitySets object
	foreach($manifestLessons as $lesson) {
		if(property_exists($lesson, "activitySets")) {
			$lessonActivitySets = $lesson->activitySets;
			$filteredActivitySets = array();

			foreach($lessonActivitySets as $activitySetId) {
				// loop through each $manifestActivitySets object and stop if we find one with an $id that matches the $activitySetId
				foreach($manifestActivitySets as $activitySet) {
					if($activitySet->activitySetId === $activitySetId) {
						$filteredActivitySets[] = $activitySetId;
						break;
					}
				}
			}
			$lesson->activitySets = $filteredActivitySets;
		}
	}


	// first filter out any unused sections in manifestLessons
	if(!empty($manifestLessons)) {
		// loop through each lesson -> section
		foreach($manifestLessons as $lesson) {
			if(property_exists($lesson, "sections")) {
				$lessonSections = $lesson->sections;
				$filteredSections = array();

				foreach($lessonSections as $sectionId) {
					// loop through each $manifestSections object and stop if we find one with an $id that matches the $sectionId
					foreach($manifestSections as $section) {
						if($section->sectionId === $sectionId) {
							$filteredSections[] = $sectionId;
							break;
						}
					}
				}
				$lesson->sections = $filteredSections;
			}
		}
	}

	// now filter out any activity sets referenced by sections but not included in the manifest
	if(!empty($manifestSections)) {
		// loop through each section -> activitySet
		foreach($manifestSections as $section) {
			if(property_exists($section, "activitySets")) {
				$sectionActivitySets = $section->activitySets;
				$filteredActivitySets = array();

				foreach($sectionActivitySets as $activitySetId) {
					// loop through each $manifestActivitySets object and stop if we find one with an $id that matches the $activitySetId
					foreach($manifestActivitySets as $activitySet) {
						if($activitySet->activitySetId === $activitySetId) {
							$filteredActivitySets[] = $activitySetId;
							break;
						}
					}
				}

				$section->activitySets = $filteredActivitySets;
			}
		}
	}

	// now start building / assembling the player manifest
	$rcfVersionForManifest = getRcfVersionForManifest();

	$playlistManifest = (object) [
		"rcfVersions" => [ $rcfVersionForManifest ],
		"activitySets" => $manifestActivitySets,
		"activities" => $manifestActivities,
	];

	if($usingGlobalStyles) {
		$manifestGlobalStyles = getGlobalStylesForManifest($serverPath);
		$playlistManifest->globalStyles = $manifestGlobalStyles;
	}

	// add "lessons" if any have been detected
	if(!empty($manifestLessons)) {
		$playlistManifest->lessons = $manifestLessons;
	}

	// add "sections" if any have been detected
	if(!empty($manifestSections)) {
		$playlistManifest->sections = $manifestSections;
	}

	if(!empty($manifestReferenceContents)) {
		$playlistManifest->referenceContents = $manifestReferenceContents;
	}

	// return the playlist manifest as json
	$app->response()->setBody(json_encode($playlistManifest, JSON_UNESCAPED_SLASHES));
});

function getActivitySetPathFromServerPath($serverPath) {
	// first check that it has ActivitySet_NN in the path
	$pattern = '/.*\/ActivitySet_\d+/';
	if(!preg_match($pattern, $serverPath)) {
		return "";
	}

	$pattern = '/(.*\/ActivitySet_\d+).*/';
	$replacement = '$1';
	$activitySetPath = preg_replace($pattern, $replacement, $serverPath);

	return $activitySetPath;

}

function getSectionPathFromServerPath($serverPath) {
	// first check that it has Section_NN in the path
	$pattern = '/.*\/Section_\d+/';
	if(!preg_match($pattern, $serverPath)) {
		return "";
	}

	$pattern = '/(.*\/Section_\d+).*/';
	$replacement = '$1';
	$sectionPath = preg_replace($pattern, $replacement, $serverPath);

	return $sectionPath;
}

function getLessonPathFromServerPath($serverPath) {
	// first check that it has Lesson_NN in the path
	$pattern = '/.*\/Lesson_\d+/';
	if(!preg_match($pattern, $serverPath)) {
		return "";
	}

	$pattern = '/(.*\/Lesson_\d+).*/';
	$replacement = '$1';
	$lessonPath = preg_replace($pattern, $replacement, $serverPath);

	return $lessonPath;
}
