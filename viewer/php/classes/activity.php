<?php

require_once("includes.php");

class Activity extends JSONObject {
	//
	public function __construct($fileName) {
		parent::__construct($fileName);
		$this->schema = XSD_ACTIVITY;
		$this->xslTemplateJSON = XSL_JSON;
		$this->backgroundImage = "not-set";
		$this->itemsFileName = str_replace(".xml", ".items", $this->fileName);
	}

	public function getMetaData() {
		// gets metadata in json format from xslt
		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);

		// get the xsltprocessor from the factory/cache
		$proc = XsltFactory::get('../xsl/utilities/activity_metadata.xsl');

		$metadata = $proc->transformToXML( $xmlDoc );
		return json_decode($metadata);
	}

	//
	public function getHTML($editing) {
		//
		$result = parent::getHTML($editing);
		//
 		return $result;
	}

	private function getCSS() {
		$cssFile = str_replace(".xml", ".css", $this->fileName);
		if(file_exists($cssFile)) {
			return file_get_contents($cssFile);
		}
		return "";
	}

	private function get768CSS() {
		$css768File = str_replace(".xml", "_768.css", $this->fileName);
		if(file_exists($css768File)) {
			return file_get_contents($css768File);
		}
		return "";
	}

	public function setCSS($css) {
		$cssFile = str_replace(".xml", ".css", $this->fileName);
		if(file_exists($cssFile)) {
			file_put_contents($cssFile, $css, LOCK_EX);
		}
	}

	public function set768CSS($css) {
		$css768File = str_replace(".xml", "_768.css", $this->fileName);
		file_put_contents($css768File, $css, LOCK_EX);
	}

	public function getAsJSON($editing) {
		// get entire activity (HTML,JSON, etc)
		$nextActivity = null;
		$previousActivity = null;

		$backgroundImage = null;

		if(!stripos($this->getFileName(), "referencecontent")) {
			$nextActivity = $this->getNext();
			$previousActivity = $this->getPrevious();
		}
		$nextID = "";
		$previousID = "";

		if($nextActivity!=null) {
			$nextID = getAngularLink($nextActivity->fileName, basename($nextActivity->getFileName()));
		}
		if($previousActivity!=null) {
			$previousID = getAngularLink($previousActivity->fileName, basename($previousActivity->getFileName()));
		}
		// locate parent unit folder
		$quit = false;
		$curr = $this->fileName;

		while(!$quit) {
			$curr = dirname($curr);
			if($curr=="" || $curr==".") {
				break;
			}

			if(startsWith(strtolower(basename($curr)), "unit_")) {
				$metaDataFileName = $curr . "/metadata.xml";
				if(file_exists( $metaDataFileName )) {
					$metaDataObject = new SimpleXMLElement( file_get_contents ($metaDataFileName) );
					if(property_exists($metaDataObject, "backgroundImage")) {
						$backgroundImage = basename($metaDataObject->backgroundImage['url']);
					}
					$metaDataObject = null;
				}
				$quit = true;
			} else {
				if(strcasecmp(basename($curr), "content")==0) {
					$quit = true;
				}
			}
		}

		$metadata = $this->getMetaData();

		$results = array(
			"hasItems"=>$this->hasItems(),
			"id"=> $this->getID(),
			"level"=>getLevelFromFileName($this->fileName),
			"breadCrumbPath"=>$this->getBreadCrumbs(),
			"fileName"=> $this->getFileName(),
			"htmlContent" => $this->getHTML($editing),
			"xmlContent" => $this->getXML(),
			"jsonContent" => $this->getJSON(),
			"css" => $this->getCSS(),
			"css768" => $this->get768CSS(),
			"backgroundImage" => $backgroundImage,
			"activityMode" => $metadata->{'activityMode'},
			"gradable" => $metadata->{"gradable"},
			"availablePoints" => $metadata->{"availablePoints"},
			"teacherPoints" => $metadata->{"teacherPointsAvailable"},
			"pointsAvailable" => $metadata->{"pointsAvailable"},
			"nextActivityID" => $nextID,
			"prevActivityID"=>$previousID,
			"tocName" => $this->getActivityTitleForTableOfContents(),
			"mq768" => MEDIAQUERY_768
		);

		logError("checking if getReferenceContentIds exists for the activity.php class");

		if(method_exists($this, 'getReferenceContentIds')) {
			$referenceContentIds = $this->getReferenceContentIds();
			if($referenceContentIds) {
				$results['referenceContentIds'] = $referenceContentIds;
			}
		}


		// add items xml if there is any
		if($this->hasItems()) {
			$activityItems = $this->getItems();
			$results['itemsXml'] = $activityItems->getXML();
			$results['itemsToc'] = $this->getItemsTOC();
			$results['firstItemId'] = $activityItems->getFirstItemId();
			$results['itemSets'] = $this->getItemSets();
		}
/* TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO

	 we need to really use a transformation to :

		1. get the itemSets as json
		2. get the activity mode into the json for the activity

	We should look into how many times the xml is being read from the file system - seems like a lot !

	We need to return the activityMode in the *ACTIVITY SETS* part of the manifest
	We need to return the itemSets in the *ACTIVITY* part of the manifest


	*/

		return json_encode($results);
	}

	public function getItemSets() {

		$simpleXml = new SimpleXMLElement($this->getXML());

		$results = (object) [];

		foreach($simpleXml->itemBased->itemSet as $xmlItemSet) {
			$type = (string) $xmlItemSet['type'];
			$itemsForResults = array();
			foreach($xmlItemSet->item as $item) {
				$itemsForResults[] = (string) $item['id'];
			}
			$results->$type = $itemsForResults;
		}

		return $results;
	}

	public function getActivityTitleForTableOfContents() {
		try {
			$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);
			$xPath = new DOMXPath($xmlDoc);
			$activityTitle = $this->getMetadataTitleFromDomXPath($xPath);
			if(is_null($activityTitle)) {
				$activityTitle = $this->getRubricFromDomXPath($xPath);
			}
			return preg_replace("/\s+/", " ", $activityTitle);
		} catch(Exception $ex) {
			return "error getting metadata title or rubrics for activity";
		}
	}

	public function hasItems() {
		return (file_exists($this->itemsFileName));
	}

	public function getItemsTOC() {
		if($this->hasItems()) {
			$items = new Items($this->itemsFileName);
			return $items->getJSON();
		}
		else {
			return '[]';
		}
	}

	public function getItems() {
		return new Items($this->itemsFileName);
	}

	private function getMetadataTitleFromDomXPath($xPath) {
		$details = $xPath->query("//metadata/title");
		if (is_null($details)) {
			return null;
		}
		foreach($details as $node) {
			//Only ever one title node so return immediately
			return $node->textContent;
		}
	}

	private function getRubricFromDomXPath($xPath) {
		$rubric = "";
		$details = $xPath->query("//rubric");
		foreach($details as $node) {
			$rubric .= $node->textContent;
		}
		return $rubric;
	}

	//
	private function getNext() {
		return ActivityStore::getNextActivity($this->getFileName());
	}

	private function getPrevious() {
		return ActivityStore::getPreviousActivity($this->getFileName());
	}

}
