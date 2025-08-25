<?php

class XmlDomDocumentFactory {

	public static function getFromFile($xmlFileName) {
		$xmlDoc = new DOMDocument('1.0', 'utf-8');
		$xmlDoc->substituteEntities = true;
		$xmlDoc->load($xmlFileName);

		$error = libxml_get_last_error();

		if($error) {
			self::raiseError();
			$errors = libxml_get_errors();
		}

		return $xmlDoc;
	}

	public static function getFromString($xml) {
		$xmlDoc = new DOMDocument('1.0', 'utf-8');
		$xmlDoc->substituteEntities = true;
		$xmlDoc->loadXML($xml);
		$error = libxml_get_last_error();

		if($error) {
			self::raiseError();
		}

		return $xmlDoc;
	}

	public static function raiseError() {
		$errors = libxml_get_errors();

		$errArray = array();
		foreach($errors as $error) {
			array_push($errArray, array("line"=>$error->line, "column"=>$error->column, "description"=>$error->code . " : " . $error->message));
		}
		libxml_clear_errors();
		throw new VerifyException("Error in XML !", 98, null, $errArray);
	}

}

?>
