<?php
require_once("includes.php");

$manifestCachedActivitySetsByPath = (object) [];
$manifestCachedSectionsByPath = (object) [];

function getRcfVersionForManifest() {
	$mqDesktop = "only screen and (min-width: " . MEDIAQUERY_768 . ")";
	$mqLargeDesktop = "only screen and (min-width: " . MEDIAQUERY_1024 . ")";


	// Figure out the path build to use - either monorepo or project
	$rcfRootBuildPath = (realpath(RCF_PATH . 'dist/rcf-release')) ? 'dist/rcf-release/build' : 'build';

	// Build the rcf versions part of the manifest
	$rcfVersions = (object) [
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

	];

	return $rcfVersions;
}

function getActivitySetForManifest($serverPath) {
	// assumes the path will be for an activity set!
	$metaDataObject = new MetaData("{$serverPath}/metadata.xml");
	$metadata = json_decode($metaDataObject->getJSON());
	$activitySetTitle = $metadata->title;

	$activitySetId = $metadata->id;

	// get array of activity ids inside the activity set folder
	$activityIds = array();

	$activitySetFolder = new ProductionFolder($serverPath);

	$activitySetActivities = json_decode($activitySetFolder->getJSON());

	foreach($activitySetActivities as $activity) {
		$activityIds[] = $activity->xmlID;
	}

	$manifestActivitySet = (object) [
		"activitySetId" => $activitySetId, // for rcf-build manifest format
		"title" => $activitySetTitle,
		"activityMode" => "", // to be populated later
		"activities" => $activityIds,
		"printActivityNumber" => [ $metadata->printActivityNumber ]
	];

	if(property_exists($metadata, 'description') && $metadata->description != '') {
		$manifestActivitySet->description = $metadata->description;
	}

	if(property_exists($metadata, 'descriptionLang') && $metadata->descriptionLang != '') {
		$manifestActivitySet->descriptionLang = $metadata->descriptionLang;
	}

	return $manifestActivitySet;
}

function getActivityForManifest($activityPath) {
	// are we using global (external) styles?
	$usingExternalStyles = defined('EXTERNAL_STYLES_NAME'); // global styles ....

	// get the level name from the server path
	$level = getLevelFromFileName($activityPath);

	// build the activity object
	// define('LEVEL_ASSETS_URL', 'products/');
	$activity = ActivityStore::getActivityByPath($activityPath);

	// get the results in JSON format
	$activityJSON = json_decode($activity->getAsJSON(false));

	$activityId = $activityJSON->id;

	$activityHtml = $activityJSON->htmlContent;

	// need to do some hacking here with the level asset url because of the way the php / level assets work
	// - ideally, we'd provide a sharable levelAssetsUrl that could be used in the transformation, but because
	//   this transformation is shared with the viewer... it's very tricky to change without blowing up the
	//   viewer. But as we know what the 'hardcoded' viewer level assets url is, we can just remove most of it
	//   for the mass-player (or build) manifest we are creating here.
	//
	$activityHtml = str_replace('../production/project/', '', $activityHtml);

	// base encode the html and json
	$html = base64_encode($activityHtml);
	$json = base64_encode($activityJSON->{"jsonContent"});

	if($usingExternalStyles) { // then don't get project / level styles
		$activityCss = [];
	} else {
		$activityCss = getActivityCssObject($activityPath);
	}

	// return the activity manifest object
	$activityForManifest = (object) [
		"activityId" => $activityId, // for rcf-build manifest format
		"activityMode" => $activityJSON->{"activityMode"},
		"gradableType" => $activityJSON->{"gradable"},
		"pointsAvailable" => $activityJSON->{"pointsAvailable"},
		"teacherPointsAvailable" => $activityJSON->{"teacherPoints"},
		"minWidthMobile" => MEDIAQUERY_768,
		"rootPath" => "production/project",
		"css" => $activityCss,
		"html" => "data:text/html;base64,{$html}",
		"json" => "data:application/json;base64,{$json}"
	];

	if(property_exists($activityJSON,'itemSets')) {
		$activityForManifest->itemSets = $activityJSON->{'itemSets'};
	}

	if(property_exists($activityJSON, 'referenceContentIds')) {
		$activityForManifest->referenceContentIds = $activityJSON->{'referenceContentIds'};
	}

	if($usingExternalStyles) {
		$activityForManifest->globalStyles = "latest";
	}

	return $activityForManifest;

}

function getReferenceContentForManifest($referenceId) {
	$referenceContent = ActivityStore::getActivityById($referenceId);

	$referenceContentJSON = json_decode($referenceContent->getPlaylistManifestJson());

	// * this is the same fix as in getActivityForManifest */
	//
	// need to do some hacking here with the level asset url because of the way the php / level assets work
	// - ideally, we'd provide a sharable levelAssetsUrl that could be used in the transformation, but because
	//   this transformation is shared with the viewer... it's very tricky to change without blowing up the
	//   viewer. But as we know what the 'hardcoded' viewer level assets url is, we can just remove most of it
	//   for the mass-player (or build) manifest we are creating here.
	//
	$html = $referenceContentJSON->{"htmlContent"};

	$html = str_replace('../production/project/', '', $html);
	$html = base64_encode($html);

	$referenceContentForManifest = (object) [
		"referenceContentId" => $referenceContentJSON->{"id"}, // for rcf-build manifest format
		"rootPath" => "production/project",
		"title" => $referenceContentJSON->{"title"},
		"type" => $referenceContentJSON->{"type"},
		"recallable" => $referenceContentJSON->{"recallable"} == "y",
		"html" => "data:text/html;base64,{$html}"
	];

	if(property_exists($referenceContentJSON, 'titleLang')) {
		$referenceContentForManifest->titleLang = $referenceContentJSON->{"titleLang"};
	}

	return $referenceContentForManifest;
}

function getSectionForManifest($sectionPath) {
	if(isset($manifestCachedActivitySetsByPath[$sectionPath])) {
		return $manifestCachedSectionsByPath[$sectionPath];
	}
	// assumes the path will be for a section
	$metaDataObject = new MetaData("{$sectionPath}/metadata.xml");
	$metadata = json_decode($metaDataObject->getJSON());

	$sectionId = $metadata->id;

	$activitySets = getActivitySetsForPath($sectionPath);

	$manifestSection = (object) [
		"sectionId" => $sectionId, // for rcf-build manifest format
		"title" => $metadata->title,
		"rootPath" => "production/project"
	];

	if(!empty($activitySets)) {
		$manifestSection->activitySets = $activitySets;
	}

	decorateManifestObject($manifestSection, $metadata, $sectionPath);

	// update the cache of sections with the object by path to stop re-reads
	$manifestCachedSectionsByPath[$sectionPath] = $manifestSection;

	return $manifestSection;

}

function getLessonForManifest($lessonPath) {
	// assumes the path will be for a lesson
	$metaDataObject = new MetaData("{$lessonPath}/metadata.xml");

	$metadata = json_decode($metaDataObject->getJSON());

	$lessonId = $metadata->id;

	$sections = getSectionsForLesson($lessonPath);
	$activitySets = getActivitySetsForPath($lessonPath);

	$manifestLesson = (object) [
		"lessonId" => $lessonId, // for rcf-build manifest format
		"title" => $metadata->title,
		"rootPath" => "production/project"
	];

	if(!empty($sections)) {
		$manifestLesson->sections = $sections;
	}

	if(!empty($activitySets)) {
		$manifestLesson->activitySets = $activitySets;
	}

	decorateManifestObject($manifestLesson, $metadata, $lessonPath);

	return $manifestLesson;

}

function decorateManifestObject($manifestObject, $metadata, $objectFilePath) {
	//
	// de-duplicated code for decorating manifest objects with metadata into this function
	if(property_exists($metadata, 'titleLang') && $metadata->titleLang != '') {
		$manifestObject->titleLang = $metadata->titleLang;
	}

	if(property_exists($metadata, 'subtitle') && $metadata->subtitle != '') {
		$manifestObject->subtitle = $metadata->subtitle;
	}

	if(property_exists($metadata, 'subtitleLang') && $metadata->subtitleLang != '') {
		$manifestObject->subtitleLang = $metadata->subtitleLang;
	}

	if(property_exists($metadata, 'description') && $metadata->description != '') {
		$manifestObject->description = $metadata->description;
	}

	if(property_exists($metadata, 'headerBackgroundColor') && $metadata->headerBackgroundColor != '') {
		$manifestObject->headerBackgroundColor = $metadata->headerBackgroundColor;
	}

	if(property_exists($metadata, 'headerTextColor') && $metadata->headerTextColor != '') {
		$manifestObject->headerTextColor = $metadata->headerTextColor;
	}

	if(property_exists($metadata, 'navigationSeparatorColor') && $metadata->navigationSeparatorColor != '') {
		$manifestObject->navigationSeparatorColor = $metadata->navigationSeparatorColor;
	}

	if(property_exists($metadata, 'headerImage')) {

		$sharedAssetsUrl = 'shared/assets/';

		$manifestObject->assets = (object) [
			"headerImage" => (object) [
				"type" => $metadata->headerImage->type,
				"path" => $sharedAssetsUrl . $metadata->headerImage->path
			]

		];

	}
}

function getActivitySetsForPath($serverPath) {

	if(isset($manifestCachedActivitySetsByPath[$serverPath])) {
		return $manifestCachedActivitySetsByPath[$serverPath];
	}

	// return an array of activity set ids for a $serverPath
	$activitySetFolders = glob($serverPath . "/ActivitySet_*", GLOB_ONLYDIR);

	// if there are no child folders, return an empty array
	if(empty($activitySetFolders)) {
		return array();
	}

	// create the array of activity set ids
	$activitySets = array();
	foreach($activitySetFolders as $folder) {
		$activitySet = new MetaData($folder . "/metadata.xml");

		$json = json_decode($activitySet->getJSON());
		$activitySets[] = $json->id;
	}

	$manifestCachedActivitySetsByPath[$serverPath] = array_unique($activitySets);
	return array_unique($activitySets);
}

function getSectionsForLesson($lessonPath) {
	// return an array of section ids for a $lessonPath
	$lessonChildFolders = glob($lessonPath . "/Section_*", GLOB_ONLYDIR);

	// if there are no child folders, return an empty array
	if(empty($lessonChildFolders)) {
		return array();
	}

	$sections = array();
	foreach($lessonChildFolders as $folder) {
		if(isset($manifestCachedSectionsByPath[$folder])) {
			$section[]=$manifestCachedSectionsByPath[$folder];
		} else {
			$section = new MetaData($folder . "/metadata.xml");
			$json = json_decode($section->getJSON());
			$sections[] = $json->id;
			$manifestCachedSectionsByPath[$folder] = $json->id;
		}
	}

	return array_unique($sections);

}

function getActivityCssObject($activityPath) {
	//
	// media queries for css in manifest
	$mqDesktop = "only screen and (min-width: " . MEDIAQUERY_768 . ")";
	$mqLargeDesktop = "only screen and (min-width: " . MEDIAQUERY_1024 . ")";

	$level = getLevelFromFileName($activityPath);

	$projectAssetsPath = "shared/style/";
	$manifestLevelAssetsPath = "products/{$level}/assets/style/";

	// global styles added once for the viewer / adapter - will have key 'latest'
	// return array_merge(
	return
		[
			(object) [
				"path" => $projectAssetsPath . PROJECT_CSS
			],
			(object) [
				"path" => $projectAssetsPath . PROJECT_CSS_768,
				"mediaQuery" => $mqDesktop
			],
			(object) [
				"path" => $projectAssetsPath . PROJECT_CSS_1024,
				"mediaQuery" => $mqLargeDesktop
			],
			// level css
			(object) [
				"path" => $manifestLevelAssetsPath . "level.css"
			],
			(object) [
				"path" => $manifestLevelAssetsPath . "level_768.css",
				"mediaQuery" => $mqDesktop
			],
			(object) [
				"path" => $manifestLevelAssetsPath . "level_1024.css",
				"mediaQuery" => $mqLargeDesktop
			]
		]
	;
}

function getGlobalStylesForManifest($serverPath) {
	$mqDesktop = "only screen and (min-width: " . MEDIAQUERY_768 . ")";
	$mqLargeDesktop = "only screen and (min-width: " . MEDIAQUERY_1024 . ")";

	// fix for the EXTERNAL_ASSETS_FOLDER being '../<folder name>' in rcf-project-source
	// neeed to remove the PROJECT_PATH variable value from EXTERNAL_ASSETS_FOLDER and use that
	$externalAssetsFolder = str_replace(PROJECT_PATH, '', EXTERNAL_ASSETS_FOLDER);

	$globalStylesForManifest = (object) [
		"latest" => (object) [
			"rootPath" => "",
			"version" => "latest",

			"css" => [
				(object) [
					"path" => $externalAssetsFolder . '/style/' . EXTERNAL_STYLES_NAME
				],
				(object) [
					"path" => $externalAssetsFolder . '/style/' . EXTERNAL_STYLES_NAME_768,
					"mediaQuery" => $mqDesktop
				],
				(object) [
					"path" => $externalAssetsFolder . '/style/' . EXTERNAL_STYLES_NAME_1024,
					"mediaQuery" => $mqLargeDesktop
				]
			]
		]
	];

	return $globalStylesForManifest;

}
?>

