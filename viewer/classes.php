<?php

// Start new or resume existing session
session_start();

// use the xml errors from libxml for validation issues etc
libxml_use_internal_errors(true);

// set include path to viewer/php
set_include_path('./php');

// include the globals / defines
require_once("./php/includes.php");


// include the classes - loading order is important (thanks php) - base classes need to load first
require_once('./php/classes/transformableObject.php');
require_once('./php/classes/jsonObject.php');
require_once('./php/classes/activity.php');
require_once('./php/classes/searchEngine.php');
require_once('./php/classes/items.php');
require_once('./php/classes/activityStore.php');
require_once('./php/classes/exceptions.php');
require_once('./php/classes/metadata.php');
require_once('./php/classes/productionFolder.php');
require_once('./php/classes/rcfProject.php');
require_once('./php/classes/referenceContent.php');
require_once('./php/classes/xsltFactory.php');
require_once('./php/classes/xmlDomDocumentFactory.php');
