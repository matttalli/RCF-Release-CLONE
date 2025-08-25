<?php

class XsltFactory {

	static $_processors = array();

	public static function get($fileName) {
		// these only live as long as the current request made to the server
		// - useful when the 'metadata.xml' is being processed in the hierarchy
		if(!isset(self::$_processors[$fileName])) {

			// load the xslt into a dom
			$xslDoc = XmlDomDocumentFactory::getFromFile($fileName);

			// build an XSLTProcessor for the xslt
			$proc = new XSLTProcessor();
			$proc->importStylesheet($xslDoc);

			// cache it for this request
			self::$_processors[$fileName] = $proc;
		} else {
			$proc = self::$_processors[$fileName];
		}
		return $proc;
	}
}
