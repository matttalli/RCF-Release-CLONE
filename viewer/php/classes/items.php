<?php

require_once("includes.php");

final class Items extends JSONObject {
	//
	public function __construct($fileName) {
		parent::__construct($fileName);
		$this->schema = XSD_ITEMS;
		$this->xslTemplateHTML = XSL_ITEMS;
		$this->xslTemplateJSON = XSL_ITEMS_TOC;
	}

	public function getHTML($itemIndexOrId = '') {
		// throw exception
		throw new ItemsRenderingException('Items are rendered in the Activity->getHTML method');
	}

	public function getXML($itemId = '') {

		if(!file_exists($this->fileName)) {
			return;
		}

		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);

		// if no item id specified, return all xml
		if(!$itemId) {
			return $xmlDoc->saveXML($xmlDoc->documentElement);
		}

		// otherwise return specified node if possible
		$xPath = new DOMXPath($xmlDoc);

		$itemNode = $xPath->query("/itemList/item[@id='" . $itemId . "']")->item(0);

		return $itemNode->ownerDocument->saveXML($itemNode);

	}

	public function getNumberOfItems() {
		if(!file_exists($this->fileName)) {
			return 0;
		}
		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);
		$xPath = new DOMXPath($xmlDoc);

		return $xPath->query("//itemList/item")->length;

	}

	public function getFirstItemId() {

		if(!file_exists($this->fileName)) {
			return '';
		}

		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);
		$xPath = new DOMXPath($xmlDoc);

		$itemNodes = $xPath->query("//itemList/item");

		return $itemNodes->item(0)->getAttribute("id");
	}

	public function verifyXML($xml) {

		$xmlDoc = XmlDomDocumentFactory::getFromString($xml);
		// now validate against the items schema
		if(!file_exists($this->schema)) {
			throw VerifyException("The schema does not exist ! [$this->schema]");
		}

		if (!$xmlDoc->schemaValidate($this->schema)) {
			$errors = libxml_get_errors();

			$errArray = array();
			$message = '';
			foreach($errors as $error) {
				array_push($errArray, array("line"=>$error->line, "column"=>$error->column, "description"=>$error->code . " : " . $error->message));
			}
 			libxml_clear_errors();

			throw new VerifyException("Error validating Items XML against schema [$this->schema] !", 88, null, $errArray);

		}
		// we are ok...
		// return the (possibly) modified xml
		return $xmlDoc->saveXML($xmlDoc->documentElement);
	}

}

?>
