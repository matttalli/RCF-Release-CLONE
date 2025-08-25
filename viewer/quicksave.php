<?php
/* later....
require_once("includes.inc");
require_once("lib.php");
require_once("classes.php");


if(!isset($_POST["want"])) {
	header("HTTP/1.0 500 Invalid action !");
	return;
}

$want = $_POST["want"];

$changes = $_POST["jsonChanges"];

if($want=="savechanges") {
	$id = $_POST["id"];
	$xpath = $_POST["xpath"];
	$newValue = $_POST["value"];
	logError("$xpath = $newValue");
	echo saveActivityChanges($id, $xpath, $newValue);
	return;
}

header("HTTP/1.0 501 Not sure what to do");

function saveActivityChanges($id, $xpath, $newValue) {
//
	$activity = ActivityStore::getActivityByID($id);
	if($activity!=null) {
		$activity->applyChanges($xpath, $newValue);
		$xml = $activity->getXML();
		$activity->setXML($xml);
		return $xml;
	} else {
		header("HTTP/1.0 404 Activity not found!");
	}
}
*/
?>
