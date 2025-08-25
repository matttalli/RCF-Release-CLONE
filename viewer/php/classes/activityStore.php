<?php

require_once("includes.php");

class ActivityStore {

	public static function getActivityArray ($refresh) {

		// sometimes the docker container / OS can be an hour out - so increase this value to 62 minutes !
		$rebuildCache = $refresh || (file_exists(RCF_CACHE_STRUCTURE) && ((time() - filemtime(RCF_CACHE_STRUCTURE)) > 3720));

		// if forced refresh, then remove cached results
		if($rebuildCache) {
			logError("[STRUCTURE-CACHE] - is out of date ... needs rebuilding ...");
			logError("[STRUCTURE-CACHE] - Clearing Activity Array Cache");
			/* fix issue on WAMP where error reporting will show a warning for this message and break things */
			if(file_exists(RCF_CACHE_STRUCTURE)) {
				unlink(RCF_CACHE_STRUCTURE);
			}
			logError("[MISC] - removing file cache to be sure");
			clearFileCache();
		}

		logError("[MISC] - checking if cache structure file exists");
		if(file_exists(RCF_CACHE_STRUCTURE)) {
			touch(RCF_CACHE_STRUCTURE);
			return json_decode(file_get_contents(RCF_CACHE_STRUCTURE), true);
		}

		// we got this far, so we are going to have to rebuild the cache/searchable files
		logError("[STRUCTURE-CACHE] - Rebuilding activity cache");

		// set a start time so we can record how long it took
		$start = microtime(true);

		// array to hold all the activity xml file names
		$activityXmlFiles = array();
		// array to hold all the metadata.xml and <guid>.items file names
		$metadataAndItemFiles = array();

		// define our root folder and iterators
		$rootFolder = CONTENT_URL . "/project/products/";
		$rootFolderIterator = new RecursiveDirectoryIterator($rootFolder);
		$iterator = new RecursiveIteratorIterator($rootFolderIterator);


		// loop through the iterator files
		foreach($iterator as $file) {
			// if $file ends with xml and is not metadata.xml then add it to the array
			$unixFileName = str_replace("\\", "/", $file->getPathName());

			if($file->isFile()) {
				if($file->getExtension() === 'xml') {
					if($file->getFileName() === 'metadata.xml') {
						// add it to the metadata and item files array
						$metadataAndItemFiles[] = $unixFileName;
					} else {
						// it's an activity xml file
						$activityXmlFiles[] = $unixFileName;
					}
				} else if($file->getExtension() === 'items') {
					// add it to the metadata and item files array
					$metadataAndItemFiles[] = $unixFileName;
				}
			}
		}

		// sort the metadata / item files
		usort($metadataAndItemFiles, "activitySort");
		logError('[SEARCH] - found ' . sizeof($metadataAndItemFiles) . ' files for searching');
		// save the metadata / item files names
		file_put_contents(RCF_SEARCHABLE_FILES, json_encode($metadataAndItemFiles), LOCK_EX);

		// user sort with our custom 'activitySort' function from lib.php - this is necessary because when hosted on a linux machine (not OSX ! think EC2 instances), well... things go a bit 'quirky'
		usort($activityXmlFiles, "activitySort");
		logError("[STRUCTURE-CACHE] - Storing Activity Cache - found " . sizeof($activityXmlFiles) . " activities");
		// save the array of activity xml files
		file_put_contents(RCF_CACHE_STRUCTURE, json_encode($activityXmlFiles), LOCK_EX);

		$end = microtime(true);
		logError("[STRUCTURE-CACHE] - Activity cache rebuilt in " . ($end - $start) . " seconds");
		return $activityXmlFiles;
	}

	public static function getActivityIDArray() {
		$activities = ActivityStore::getActivityArray(true);
		$results =  array();
		for($i=0; $i < sizeof($activities); $i++) {

			$chunks = explode('/', $activities[$i] );
			$id = str_replace(".xml", "", $chunks[sizeof($chunks)-1]);
			array_push($results, $id);
		}
		return $results;
	}


	public static function getActivityByPath($path) {
		$activityArray = ActivityStore::getActivityArray(false);
		$usePath = "";
		for($i=0; $i<sizeof($activityArray); $i++) {
			$pos = strpos($activityArray[$i], $path);
			if($pos!==false) {
				$usePath = $activityArray[$i];
				break;
			}
		}
		if($usePath!="") {
			return ActivityStore::getActivity($usePath);
		} else {
			return null;
		}
	}

	public static function getActivityByID($id) {
		//
		$activityArray = ActivityStore::getActivityArray(false);
		$usePath = "";
		for($i=0;$i<sizeof($activityArray);$i++) {
			$pos = strpos($activityArray[$i], $id);
			if($pos!==false) {
				$usePath = $activityArray[$i];
				break;
			}
		}
		if($usePath!="") {
			return ActivityStore::getActivity($usePath);
		} else {
			return null;
		}
	}

	public static function getNextActivity($id) {
		$activityArray = ActivityStore::getActivityArray(false);

		$pos = array_search($id, $activityArray);
		if($pos===false) {
			return null;
		}

		if($pos<sizeof($activityArray)-1) {
			$newID = $activityArray[ $pos+1 ];
			return ActivityStore::getActivity($newID);
		}
		return null;
	}

	public static function getPreviousActivity($id) {
		$activityArray = ActivityStore::getActivityArray(false);

		$pos = array_search($id, $activityArray);
		if($pos===false) {
			return null;
		}

		if($pos>0) {
			$newID = $activityArray[ $pos-1 ];
			return ActivityStore::getActivity($newID);
		}

		return null;
	}

	/*
	 * This function is used to get the table of contents structure for the mass player
	 * It returns a keyed object by viewer path, eg
	 *
	 *     "L0/U01/AS01/A01": {
	 *        "id": "4757677a45564fd5999da4b3bb3eab72",
	 *         "pointsAvailable": "0",
	 *         "teacherPointsAvailable": "0",
	 *         "availablePoints": "0",
	 *         "activityMode": "",
	 *         "gradable": "non-gradable",
	 *         "type": "activity",
	 *         "title": "Styling check for mobile / desktop styles"
	 *     },
	 *     "L0/U02/S01/AS01/A01": {
	 * 			etc
	 */
	public static function getTocStructure() {
		$activityArray = ActivityStore::getActivityArray(false);
		$tocResults = (object) [];

		$xmlDoc = new DOMDocument();

		$xsltProcessor = XsltFactory::get('../xsl/utilities/activity_metadata.xsl');

		foreach($activityArray as $filePath) {
			$fileName = basename($filePath, '.xml');
			$angularId = getAngularLink($filePath, $fileName);
			$angularId = str_replace(".xml", "", $angularId);

			$xmlDoc->load($filePath);
			$result = $xsltProcessor->transformToXML($xmlDoc);

			$tocResults->{ $angularId } = json_decode($result);

		}

		// now restructure the object to be keyed by the activity sets
		$tocByActivitySet = (object) [];

		foreach($tocResults as $key => $value) {
			// $pattern = '/^(.*\/AS\d{1,2})/';
			$pattern = '/^(.*\/AS\d+)/';
			if(preg_match($pattern, $key, $matches)) {
				$activitySetId = $matches[1];
				if(!isset($tocByActivitySet->{$activitySetId})) {

					$serverPath = getServerPathFromAngularPath($activitySetId, true);
					$activitySetMetadata = new MetaData($serverPath . "/metadata.xml");
					$activitySetJson = json_decode($activitySetMetadata->getJSON());
					logError("[TOC] - Activity Set Metadata: " . json_encode($activitySetJson));

					$tocByActivitySet->{$activitySetId} = (object) [
						"id" => $activitySetJson->id,
						"title" => $activitySetJson->title,
						"subtitle" => $activitySetJson->subtitle,
						"description" => $activitySetJson->description,
						"activities" => array()
					];
				}

				$tocByActivitySet->{$activitySetId}->activities[]  = $value;
			}
		}



		// return json_encode($tocResults, JSON_UNESCAPED_SLASHES);
		return json_encode($tocByActivitySet, JSON_UNESCAPED_SLASHES);
	}

	protected static function getActivity($path) {
		if(strpos($path, 'referenceContent')===false) {
			return new Activity($path);
		} else {
			return new ReferenceContent($path);
		}
	}

}

