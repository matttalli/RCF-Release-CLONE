<?php

require_once("includes.php");

/**
 * JSONObject abstract class
 *
 * defines that an object can be transformed into JSON
 * eg
 * 	- activity
 * 	- metadata
 *
 * Each object extending this class should have their own xsl template to handle the transformation from xml -> json
 * eg:
 * 	- activity - transforming from xml to json answers
 * 	- metadata - transforming from xml to json for the viewer editing forms
 */
abstract class JSONObject extends TransformableObject {
	//
	protected $xslTemplateJSON;
	//
	public function getJSON() {
		//
		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);

		// get the xsltprocessor from the factory/cache
		$proc=XsltFactory::get($this->xslTemplateJSON);

		$itemsFileName = str_replace(".xml", ".items", $this->fileName);
		if(file_exists($itemsFileName)) {
			$realPathFileName = realpath($itemsFileName);
			if(strpos($realPathFileName, '\\')) {
				$useFileName = "/" . str_replace("\\", "/", substr($realPathFileName, 3));
			} else {
				$useFileName = $realPathFileName;
			}
			$proc->setParameter("", "itemsFileName", 'file://' . $useFileName );;
		}

		$penaliseWrongAnswers = ( isset($_SESSION['penaliseWrongAnswers']) ? $_SESSION['penaliseWrongAnswers'] : PENALISE_WRONG_ANSWERS );

		$proc->setParameter("", "rcfVersion", RCF_VERSION);
		$proc->setParameter("", "penaliseWrongAnswers", $penaliseWrongAnswers);

		return $proc->transformToXML($xmlDoc);
	}

	public function getAsJSON($editing) {
		$results = array(
			"id"=>$this->getID(),
			"level"=>getLevelFromFileName($this->fileName),
			"breadCrumbPath"=>$this->getBreadCrumbs(),
			"fileName"=>$this->getFileName(),
			"htmlContent"=>$this->getHTML($editing),
			"xmlContent"=>$this->getXML(),
			"jsonContent"=>$this->getJSON(),
			"gradable"=>"non-gradable"
		);
		return json_encode($results);
	}
}
?>
