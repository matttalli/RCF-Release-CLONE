<?php

	set_include_path('./php');

	require_once("classes.php");

    logError('[REST-API] - call made to rest api');

    require 'Slim/Slim.php';

    \Slim\Slim::registerAutoLoader();

    $app = new \Slim\Slim();

    require_once('./php/routes/index.php');

    $app->run();
