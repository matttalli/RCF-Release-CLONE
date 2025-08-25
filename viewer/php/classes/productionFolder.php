<?php

require_once("includes.php");

class ProductionFolder extends JSONObject {
	//
	protected $path;
	protected $folderName;		// physical folder name, eg: "Unit_01"
	protected $folderTitle;		// folder name and metadata/subtitle (or metadata/title if activityset)
	protected $folderSubtitle;	// 'metadata/subtitle' value
	protected $hasMetaData;
	protected $parentName;		// parent folder 'basename'
	protected $breadCrumbPath;	// angular breadcrumb path
	protected $location;		// angular location
	protected $metaData;
	protected $ignore = array(".", "..", "assets", "project_hierarchy.xml");

	public function __construct($path) {
		$this->path = $path;
		$this->folderName = basename($path);
		$this->parentName = basename( dirname($path) );
		$this->metadata = null;

		$tmpName = strtolower($this->folderName); // eg. activityset_01

		$metaDataFileName = $path . "/metadata.xml";
		if(file_exists( $metaDataFileName )) {
			$metaDataObject = new MetaData( $metaDataFileName );

			$metaDataJSON = json_decode( $metaDataObject->getJSON() );
			$this->metadata = $metaDataJSON;

			$title = $metaDataJSON->title;
			$subtitle = $metaDataJSON->subtitle;

			$useTitle = "";
			if($title) {
				$useTitle = $title;
			} else {
				$useTitle = $subtitle;
			}
			$this->folderTitle = str_replace("_", " " , $this->folderName . " : " . $useTitle);
			$this->folderSubtitle = $subtitle;
			$this->hasMetaData = true;
		} else {
			$this->folderTitle = str_replace("_", " ", basename($path));
		}
		$this->location = getAngularLink($this->path, "");
	}

	public function getMetaData() {
		return $this->metadata;
	}
	public function getFolderTitle() {
		return $this->folderTitle;
	}

	public function getFolderSubtitle() {
		return $this->folderSubtitle;
	}

	public function getFolderName() {
		return $this->folderName;
	}

	public function getFolderLocation() {
		return $this->location;
	}

	public function getJSON() {
		// returns JSON object (list) of files / folders
		$results = array();

		$hasReferenceContent = false;
		$hasHtmlContent = false;

		// check the folder we are reading in....
		// - activityset folder, then read in all activities from each child activity folder
		// - referenceContent - read in each reference item
		// - otherwise read each folder and check for metadata inside it
		//
		if(startsWith(strtolower($this->folderName), "activityset_")) {
			$folders = glob($this->path . "/*", GLOB_ONLYDIR);
			foreach($folders as $folder) {
				// check if a disallowed folder ('.', '..', '.DS_STORE' etc)
				if(in_array($folders, $this->ignore)) {
					continue;
				}

				// read XML files from 'activity' folder
				$activityFiles = glob($folder . "/*.xml", GLOB_NOSORT);
				if(count($activityFiles)<1) {
					continue;
				}

				// create a production folder object for the folder
				$activityFolder = new ProductionFolder($folder);
				// sort the activity files
				natsort($activityFiles);
				// loop through each activity xml file and get the title from the xml file for displaying in the toc
				foreach($activityFiles as $activityFile) {
					$fileLink = CONTENT_URL . str_replace(CONTENT_URL, "", $activityFile);
					$activity = new Activity($activityFile);
					$activityMetadata = $activity->getMetaData();
					// get any items associated with the $activity
					// returns an array of items (or empty array)
					$items = json_decode($activity->getItemsTOC());
					//
					array_push($results,
						array(
							"name"=>$activityFolder->getFolderTitle() . " - " . $activity->getActivityTitleForTableOfContents(),
							"activityMode"=>explode(' ', $activityMetadata->{"activityMode"}),
							"fileName"=>basename($activity->getFileName()), "xmlID"=>$activity->getID(),
							"class"=>"navActivityLink",
							"type"=>"activity",
							"gradableType"=>$activityMetadata->{"gradable"},
							"location"=>$activityFolder->location,
							"items"=>$items
						)
					);
					//
				}
			}
		} else if(strtolower($this->folderName)=="referencecontent") {
			$referenceFiles = glob($this->path . "/*.xml", GLOB_NOSORT);
			if(count($referenceFiles) > 0) {
				foreach($referenceFiles as $referenceFile) {
					if($referenceFile!="metadata.xml") { // shouldn't be one in there, but just in case !
						$location = getAngularLink($referenceFile, basename($referenceFile) ) . "/" . basename($referenceFile);
						array_push($results, array("name"=>basename($referenceFile), "xmlID"=>str_replace(".xml", "", basename($referenceFile)), "class"=>"navActivityLink", "type"=>"reference", "location"=>$location));
					}
				}
			}
		} else if(strtolower($this->folderName) == "html") {
			// html asssets folder
			$htmlFiles = glob($this->path . "/*.html", GLOB_NOSORT);
			if(count($htmlFiles)>0) {
				foreach($htmlFiles as $htmlFile) {
					$location = "/". getAngularLink($htmlFile, basename($htmlFile) ) . "/" .basename($htmlFile);
					array_push($results, array("name"=>basename($htmlFile), "class"=>"navActivityLink", "type"=>"html", "location"=> $location));
				}
			}
		} else { // it's a list of levels, or a branch / unit / section
			//
			if(strtolower($this->folderName)=="content") {
				// check for html + reference content folders
				$parentFolder = dirname($this->path);
				$hasReferenceContent = file_exists($parentFolder . "/referenceContent");
				$hasHtmlContent = file_exists($parentFolder . '/assets/html');
			}
			$folders = glob($this->path . "/*", GLOB_ONLYDIR);
			if(count($folders) > 0) {
				$tmpTitle = "";
				foreach($folders as $branchFolder) {
					$prodFolder = new ProductionFolder($branchFolder);
					$isActivitySetLink = startsWith(strtolower(basename($branchFolder)), "activityset_");
					array_push($results, array("name"=>$prodFolder->folderTitle, "class"=>"navFolderLink", "isActivitySetLink"=>$isActivitySetLink, "type"=>"folder", "location"=>$prodFolder->location, "metadata"=>$prodFolder->getMetaData()) );
				}
			}
		}

		if($hasReferenceContent) {
			array_push($results, array("name"=>"Reference Content", "class"=>"navFolderLink", "isActivitySetLink"=>false, "type"=>"folder", "isReferenceContent"=>true));
		}

		if($hasHtmlContent) {
			array_push($results, array("name"=>"HTML Content", "class"=>"navFolderLink", "isActivitySetLink"=>false, "type"=>"folder", "isHtmlContent"=>true));
		}

		return json_encode($results);
	}

	//
	public function getBreadCrumbs() {
		//
		if(strtolower($this->folderName)=="referencecontent") {
			return json_encode("[]");
		}
		//
		$paths = array();
		$pathTitles = array();
		array_push($pathTitles, $this->folderTitle);
		array_push($paths, getAngularLink($this->path, basename($this->path)));
		$quit = false;
		$curr = $this->path;

		while(!$quit) {
			$curr = dirname($curr);
			if($curr=="" || $curr==".") {
				break;
			}
			if(strcasecmp(basename($curr), "content")==0) {
				$curr = dirname($curr);
				$quit = true;
			}
			$metaDataFile = $curr . "/metadata.xml";
			//
			$pathTitle = basename($curr);
			//
			// check if metadata, then read title / subtitle depending on where we are
			if( file_exists($metaDataFile) ) {
				//
				$metaDataObject = new MetaData( $metaDataFile );
				$val = $metaDataObject->getJSON();
				$metaDataJSON = json_decode( $val );
				//
				if(startsWith(strtolower(basename($curr)), "activityset")) {
					$useTitle = ( ($metaDataJSON->title!="") ? $metaDataJSON->title : $pathTitle);
				} else {
					$useTitle = ( ($metaDataJSON->subtitle!="") ? $metaDataJSON->subtitle : $pathTitle);
				}
				$pathTitle = $useTitle;
			}
			//
			array_push($pathTitles, $pathTitle);
			array_push($paths, getAngularLink($curr, basename($curr)));
		}
		// push the breadcrumbs to a json array
		$jsonResults = array();
		for($i=sizeof($paths)-1;$i>-1;$i--) {
			$jsonTitle = str_replace("_", " ", $pathTitles[$i] );
			array_push($jsonResults, array("title"=>$jsonTitle, "path"=>$paths[$i] ) );
		}
		$this->breadCrumbPath = json_encode($jsonResults);
		//
		return $this->breadCrumbPath;
	}
}
?>
