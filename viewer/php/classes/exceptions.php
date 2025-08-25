<?php

require_once("includes.php");

// xml validation exception class
class VerifyException extends Exception {
	private $_errors;
	private $_message;
	private $_code;

	public function __construct($message, $code=0, Exception $previous = null, $errors = array()) {
		parent::__construct($message, $code, $previous);
		$this->_errors = $errors;
		$this->_message = $message;
		$this->_code = $code;
	}

	public function getErrorArray() {
		return array("message"=>$this->_message,
								 "code"=>$this->_code,
								 "errors"=>$this->_errors);
	}

	public function getErrors() {
		return json_encode($this->getErrorArray());
	}
}

class ItemsRenderingException extends Exception {

	 public function __construct($message, $code = 0, Exception $previous = null) {
		parent::__construct($message, $code, $previous);
	}
}
?>
