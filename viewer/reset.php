<?php
	session_start();
	if(isset($_SESSION[CDN_PROJECT_NAME . "_array_store"])) {
		unset($_SESSION[CDN_PROJECT_NAME . "_array_store"]);
	}
	header( 'Location: index.php' )
?>