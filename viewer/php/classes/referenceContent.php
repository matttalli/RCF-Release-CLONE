<?php

require_once("includes.php");

class ReferenceContent extends JSONObject {
	//
	public function __construct($fileName) {
		parent::__construct($fileName);
		$this->schema = XSD_REFERENCE;
		$this->xslTemplateHTML = XSL_REFERENCE;
	}

	public function getJSON() {
		$results = array(
			"referenceContent" => 'No json',
			"gradableType" => 'non-gradable'
		);
		return json_encode($results);
	}

	public function getMetaData() {
		// gets metadata in json format from xslt
		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);

		// get the xsltprocessor from the factory/cache
		$proc = XsltFactory::get('../xsl/utilities/reference_content_metadata.xsl');

		$metadata = $proc->transformToXML( $xmlDoc );
		return json_decode($metadata);
	}

	// new method specifically fpr the playlist manifest json structure
	public function getPlaylistManifestJson() {
		// build the metadata from the reference content xml via a transform
		$metadata = $this->getMetaData();

		// create the json object for the playlist manifest for the reference content
		$results = array(
			"id" => $this->getID(),
			"htmlContent" => $this->getHTML(false)
		);

		// now copy the metadata from the referenceContent > json transformation
		foreach ($metadata as $key => $value) {
			$results[$key] = $value;
		}

		return json_encode($results);
	}

}

?>
