<?php

require_once("./php/lib.php");


$flush = false;

if (isset($_GET["dev"])) {
    $viewMode = "dev";
} elseif (isset($_GET["source"])) {
    $viewMode = "source";
} else {
    $viewMode = "";
}

if(isset($_GET['flush'])) {
    $flush = true;
}
logError('[FLUSH]: ' . $flush);

require_once("classes.php");

if(isset($_GET["environment"])) {
    $_SESSION["environment"] = $_GET["environment"];
} else {
    $_SESSION["environment"] = "default";
}

setUrlQueryParameters();
//
