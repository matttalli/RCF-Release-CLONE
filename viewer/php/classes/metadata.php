<?php

require_once("includes.php");

class MetaData extends JSONObject {
	//
	public function __construct($fileName) {
		parent::__construct($fileName);
		$this->xslTemplateHTML = XSL_METADATA;
	}

    //
	public function saveXml($xmlUnformattedText) {
	    $xmlDoc = new DOMDocument('1.0', 'UTF-8');
	    $xmlDoc->preserveWhiteSpace = false;
	    $xmlDoc->xmlStandalone = true;
	    $xmlDoc->formatOutput = true;
	    $header = $xmlDoc->saveXML();
        $xmlDoc->loadXML($xmlUnformattedText);

		// MAMP version of php gets upset unless we do it this way ....
		// ¯\_(ツ)_/¯
		$documentElement = $xmlDoc->documentElement;
        $body = $xmlDoc->saveXML($documentElement);
        $content = $this->spacingFormat("{$header}{$body}");

        file_put_contents($this->fileName, $content, LOCK_EX);
	}

    //
	private function createArray(&$meta, &$json, $name) {
		if(property_exists($json, $name)) {
			unset( $meta->{ $name } );
			for($i = 0; $i < count($json->{ $name }); $i++) {
				$meta->{ $name }->{ "item" }[$i] = $json->{ $name }[$i]->{ "desc" };
			}
		}
	}

	//
	public function getJSON() {
		// parent transform uses xsl in html call
		$html = parent::getHTML(false);
		// decode the html entities for display
		return html_entity_decode($html);
	}
	//
	public function setJSON($jsonValues) {
		// convert the json values to XML and save
		$metadata = new SimpleXMLElement( file_get_contents($this->fileName) ) ;

		$jsonDefaultKeys = array(
		    "id",
			"title",
			"subtitle",
			"label",
			"description",
			"component",
			"level",
			"type",
			"spkLayout",
			"spkTheme",
			"dictionary",
			"unitColor",
			"unitTextColor",
			"color",
			"colorGradient",
			"textColor",
			"termsAndConditions",
			"credits",
			"mainCategory",
			"backgroundColor",
			"instantFeedbackDelay",
			"printPageReference",
			"printActivityNumber",
			"island",
			"sourceType",
			"levelTaxonomyRoot",
			"alternativeSourceType",
			"navioTheme",
			"expiryDate",
			"activityRepresentationType"
		);

		$jsonArraysToCreate = array(
			"educationalAlignment",
			"keyCourseAim",
			"skill",
			"learningObjective",
			"grammarPronPoint",
			"lexicalSet",
			"coreVocabularyItems",
			"recycledVocabularyItems",
			"vocabularyItems",
			"printPagesReference"
		);

		foreach($jsonDefaultKeys as $key) {
			if(property_exists($jsonValues, $key)) {
				if($jsonValues->{ $key } =='') {
					unset($metadata->{ $key });
				} else {
                    $metadata->{ $key } = $jsonValues->{ $key };
				}
			}
		}


		// 'publish' attribute
		if(property_exists($jsonValues, "publish")) {
			$metadata->publish = (($jsonValues->publish) ? "y" : "n");
		}

		// 'isNewsItem' attribute
		if(property_exists($jsonValues, "isNewsItem")) {
			$metadata->isNewsItem = (($jsonValues->isNewsItem) ? "y" : "n");
		}

		// 'showOrientationDeviceNotification' attribute
		if(property_exists($jsonValues, "showOrientationDeviceNotification")) {
			$metadata->showOrientationDeviceNotification = (($jsonValues->showOrientationDeviceNotification) ? "y" : "n");
		}

		// 'inTLP' attribute
		if(property_exists($jsonValues, "inTLP")) {
			$metadata->inTLP = (($jsonValues->inTLP) ? "y" : "n");
		}

		// 'isAlternativeSourceType' attribute
		if(property_exists($jsonValues, "isAlternativeSourceType")) {
			$metadata->isAlternativeSourceType = (($jsonValues->isAlternativeSourceType) ? "y" : "n");
		}

		// 'noInheritance' attribute
		if(property_exists($jsonValues, "noInheritance")) {
			$metadata->noInheritance = (($jsonValues->noInheritance) ? "y" : "n");
		}

		foreach($jsonArraysToCreate as $array) {
			$this->createArray($metadata, $jsonValues, $array);
		}

		//This will need to be changed when multiple values are allowed
		if(property_exists($jsonValues, "alternativeSourceTypes")) {
			unset( $metadata->{ "alternativeSourceTypes" } );
			if($jsonValues->{ "alternativeSourceTypes" } != "") {
				$metadata->{ "alternativeSourceTypes" }->{ "item" }[0] = $jsonValues->{ "alternativeSourceTypes" };
			}
		}


		$imagePath = "";

		// image properties
		$jsonImageKeys = array(
			"thumb",
			"courseImage",
			"dashboardImage",
			"navflyoutImage",
			"backgroundImage",
			"coverImage",
			"logoImage",
			"activitiesImage",
			"scoreImage",
			"scoreBackground"
			);
		foreach($jsonImageKeys as $imageKey) {
			if(property_exists($jsonValues, $imageKey)) {
				if($jsonValues->{ $imageKey } !='') {
					if(!property_exists( $metadata, $imageKey )) {
						$metadata->addChild( $imageKey );
					}
					$metadata->{ $imageKey }["url"] = $imagePath . $jsonValues->{ $imageKey };
				}
			}
		}
		$categoriesKey = "activityCategories";
		if(property_exists($jsonValues, $categoriesKey)) {
			unset( $metadata->{ $categoriesKey } );
		 	$metadata->addChild( $categoriesKey );
		 	foreach($jsonValues->{ "activityCategories" } as $category) {
				$categoryXml = $metadata->{ $categoriesKey }->addChild("category", $category->{ "name" });
				$categoryXml->addAttribute("icon", $imagePath . $category->{ "icon" });
				$categoryXml->addAttribute("background", $imagePath . $category->{"background"});
			}
		}
		// MAMP version of php gets upset unless we do it this way ....
		// ¯\_(ツ)_/¯
		$xmlValue = $metadata->asXML();
		$this->saveXml($xmlValue);
	}

    /**
	 * Adds 4 indentation spaces to xml content
     * @param $xml string
     * @return string formatted
     */
	private function spacingFormat($xml) {
		return preg_replace_callback('/^( +)</m', function($a) {
            return str_repeat(' ',intval(strlen($a[1]) / 2) * 4).'<';
        }, $xml);
	}
}
