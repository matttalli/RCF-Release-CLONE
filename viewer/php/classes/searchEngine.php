<?php

require_once("includes.php");

class SearchEngine {

	public static function getSearchableFiles($refresh) {
		// searchable files are built by the main activityStore class now and written to the 'RCF_SEARCHABLE_FILES' file
		if(file_exists(RCF_SEARCHABLE_FILES)) {
			return json_decode(file_get_contents(RCF_SEARCHABLE_FILES), true);
		}

		return [];
	}

	public static function searchProductionFolder($level, $searchValue) {

		// get array of activity files
		$activityFiles = ActivityStore::getActivityArray(false);
		// get array of metadata.xml and .items files
		$otherFiles = SearchEngine::getSearchableFiles(true);

		// combine arrays into single array of filenames to search through
		$allFiles = array_merge($activityFiles, $otherFiles);

		// array for our search results
		$resultsArray = array();

		// loop through each file in the $allFiles array
		for($i=0; $i < sizeof($allFiles); $i++) {
			// get the current file path
			$usePath = $allFiles[$i];
			$search = true;

			// if we are searching in level, then restrict the search to that level
			if($level!="") {
				$fileLevel = getLevelFromFileName($usePath);
				if($fileLevel!=$level) {
					continue;
				}
			}

			// get the contents of the file
			$fileContents = file_get_contents($usePath);
			// search the contents for the search value
			$pattern = preg_quote($searchValue, '/');
			$pattern = "/^.*$pattern.*\$/im";

			// if we have a match, then build the search results json object
			if(preg_match_all($pattern, $fileContents, $matches)) {
				$basename = basename($usePath);
				$angularLink = getAngularLink($usePath, $basename);
				if(strcasecmp($basename, 'metadata.xml') == 0) {
					$type = 'Metadata';
				} else if(stripos($usePath, "referenceContent")) {
					$type = "Reference Item";
					$angularLink .= "/" . $basename;
				} else if(endsWith($usePath, '.items')) {
					$type = 'Items';
				} else {
					$type = "Activity";
				}

				array_push($resultsArray, array(
					"result"	=> $basename,
					"type"		=> $type,
					"angularLink" => $angularLink,
					"matches" => $matches[0]
				));
			}

		}
		// return the search results json
		return json_encode($resultsArray);
	}

}
?>
