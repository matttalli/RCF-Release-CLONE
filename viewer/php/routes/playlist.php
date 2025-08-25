<?php

require_once("includes.php");
require_once("lib.php");

/*
returns an array of activity ids for a given server path !
*/

$app->get("/playlist/:path+", function($path) use($app) {
	// allow cors
	$app->response()->header("Access-Control-Allow-Origin", "*");

	// return json
	$app->response()->header("Content-Type", "application/json");

	// get the supplied path (L01/U01/S01/A01 etc) into an array split by '/'
	$path = implode("/", $path);

	// get the path on the server from that supplied path
	$serverPath = getServerPathFromAngularPath($path);

	$playlist = getPlayListArray($serverPath);

	$app->response()->setBody(json_encode($playlist, JSON_UNESCAPED_SLASHES));
});

$app->get("/print-playlist/:path+", function($path) use($app) {
	// allow cors
	$app->response()->header("Access-Control-Allow-Origin", "*");
	$app->response()->header("Content-Type", "application/json");

	// get the supplied path (L01/U01/S01/A01 etc) into an array split by '/'
	$path = implode("/", $path);

	// get the path on the server from that supplied path
	$serverPath = getServerPathFromAngularPath($path);

	$playlist = getPlayListArray($serverPath);

	$printHtmlFragments = array();
	for($i = 0; $i < sizeof($playlist); $i++) {
		$serverPath = getServerPathFromAngularPath($playlist[$i]);
		$activity = ActivityStore::getActivityByPath($serverPath);
		$printHtmlFragments[] = $activity->getPrintHTML();
	}

	$app->response()->setBody(json_encode($printHtmlFragments, JSON_UNESCAPED_SLASHES));

});

$app->get('/multiple-activities/:path+', function($path) use($app){
	// gets a playlist and expands that to get json array of all the activities (html.. everything !)
	// allow cors
	$app->response()->header("Access-Control-Allow-Origin", "*");
	$app->response()->header("Content-Type", "application/json");

	// get the supplied path (L01/U01/S01/A01 etc) into an array split by '/'
	$path = implode("/", $path);



	// get the path on the server from that supplied path
	$serverPath = getServerPathFromAngularPath($path);

	$playlist = getPlayListArray($serverPath);

	$activities = array();
	for($i = 0; $i < sizeof($playlist); $i++) {
		// loop through each activity path in the playlist and get the activity object
		$serverPath = getServerPathFromAngularPath($playlist[$i]);
		$activity = ActivityStore::getActivityByPath($serverPath);
		$activities[] = json_decode($activity->getAsJSON("N"));
	}

	$app->response()->setBody(json_encode($activities, true));
});


function getPlayListArray($serverPath) {
	$activities = ActivityStore::getActivityArray(false);
	$playlist = array();
	for($i=0; $i < sizeof($activities); $i++) {
		$activityFullPath = $activities[$i];

		if(substr($activityFullPath, 0, strlen($serverPath)) == $serverPath) {
			$playlist[] = getAngularLink($activityFullPath, basename($activityFullPath));
		}
	}

	return $playlist;
}
?>
