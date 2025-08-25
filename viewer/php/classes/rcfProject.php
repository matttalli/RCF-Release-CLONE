<?php

class RcfProject {
	protected $rootFolder;
	protected $itemsById = array();
	protected $itemsByFilename = array();

	public static function getRcfItems($refresh) {
		if(!$refresh) {
			return $itemsByFilename;
		}
	}
}