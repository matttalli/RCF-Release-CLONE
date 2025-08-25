<?php

function getProjectSetting($json, $name, $defaultValue) {
    if (isset($json->projectSettings->$name)) {
        return $json->projectSettings->$name;
    } else {
        return $defaultValue;
    }
}

function startsWith($haystack, $needle) {
    return !strncmp($haystack, $needle, strlen($needle));
}

function endsWith($haystack, $needle) {
    $length = strlen($needle);
    if ($length == 0) {
        return true;
    }

    return (substr($haystack, -$length) === $needle);
}

function getLevelFromAbbr($abbr) {
    return str_replace("L", "Level_", $abbr);
}

function getLevelFromFileName($fileName) {
    //
    $parts = explode("/", $fileName);
      //
    foreach ($parts as $value) {
        if (startsWith($value, "Level")) {
            return $value;
        }
    }
    return "Level_1"; // default I guess ...
}

function get_file_extension($file_name) {
    return substr(strrchr($file_name, '.'), 1);
}

function activitySort($a, $b) {
    return strnatcmp($a, $b);
}

function getServerPathFromAngularPath($angularPath, $stripFileName = false) {
    // angularPath will be like :
    // L1/U01/AS01/A01
    $serverPath = CONTENT_URL . "/project/products/";
    $paths = explode("/", $angularPath);

    for ($i = 0; $i < sizeof($paths); $i++) {
        $pathChar = substr($paths[$i], 0, 1);
        if ($pathChar == "L") {
            $serverPath .= "Level_" . substr($paths[$i], 1);
            if ($i + 1 < sizeof($paths)) {
                $nextFolder = substr($paths[$i + 1], 0, 1);
            } else {
                $nextFolder = "";
            }

            if (($i + 1) == sizeof($paths)) {
                $serverPath .= "/content";
            } else if ($nextFolder != "R" && $nextFolder != "H") {
                $serverPath .= "/content";
            }

        } else if ($pathChar == "H") {
            $serverPath .= "/assets/html";
            if ($i < sizeof($paths) - 1) {
                $serverPath .= "/" . $paths[$i + 1];
            }
        } else if ($pathChar == "R") {
            $serverPath .= "/referenceContent";
            if(!$stripFileName) {
                if ($i < sizeof($paths) - 1) {
                    $serverPath .= "/" . $paths[$i + 1];
                }
            }
        } else if ($pathChar == "U") {
            $serverPath .= "/Unit_" . substr($paths[$i], 1);
        } else if ($pathChar == "S") {
            $serverPath .= "/Section_" . substr($paths[$i], 1);
        } else if (substr($paths[$i], 0, 2) == "EL") { //EL for Level
            $serverPath .= "/Lesson_" . substr($paths[$i], 2);
        } else if (substr($paths[$i], 0, 2) == "AS") {
            $serverPath .= "/ActivitySet_" . substr($paths[$i], 2);
        } else if ($pathChar == "A") {
            $serverPath .= "/Activity_" . substr($paths[$i], 1);
        }
    }
    return $serverPath;
}

function getAngularLink($location, $fileName) {
    //
    $insideActivitySet = stripos($location, "ActivitySet_");

    $location = str_replace("../production/project/products/", "", $location);
    $location = str_replace("../", "", $location);
    $location = str_replace("/content", "", $location);
    $location = str_replace("Level_", "L", $location);
    $location = str_replace("referenceContent", "R0", $location);
    $location = str_replace("Unit_", "U", $location);
    $location = str_replace("Lesson_", "EL", $location);
    $location = str_replace("ActivitySet_", "AS", $location);
    $location = str_replace("Section_", "S", $location);
    $location = str_replace("Activity_", "A", $location);
    $location = str_replace("/assets/html", "/H0", $location);
    if(!$insideActivitySet) {
        $location = str_replace('/metadata.xml', '', $location);
    } else {
        $location = str_replace('/metadata.xml', '/M0', $location);
    }

    $location = str_replace("/metadata.xml", "", $location);
    $location = str_replace("//", "/", $location);
    if ($fileName != "") {
        $location = str_replace("/" . $fileName, "", $location);
    }
    //
    return $location;
}

function logError($msg) {
    error_log("\n" . date('Y-m-d h:i:s') . " : " . $msg, 3, "rcf_php_errors.log");
}

function getGUID() {
    mt_srand((double)microtime() * 10000); //optional for php 4.2.0 and up.
    return (md5(uniqid(rand(), true)));
}

function getExternalAssetsFolder($projectSettings) {

    $defaultPath = 'production/project/shared';

    // check for sharedAssetsFolder or externalAssetsFolder - if neither, then just use the project shared assets
    if (!isset($projectSettings->sharedAssetsFolder) && !isset($projectSettings->externalAssetsFolder)) {
        return PROJECT_PATH . $defaultPath;
    }

    // check if new externalAssetsFolder is set, otherwise use the fallback
    if(isset($projectSettings->externalAssetsFolder)) {
        $assetsFolder = $projectSettings->externalAssetsFolder;
    } else if(isset($projectSettings->sharedAssetsFolder)) {
        $assetsFolder = $projectSettings->sharedAssetsFolder;
    }

    if (isWeb($assetsFolder)) {
        return $assetsFolder;
    }

    $assetsFolderLocalPath = PROJECT_PATH . $assetsFolder;

    if(!file_exists($assetsFolderLocalPath)) {
        return PROJECT_PATH . $defaultPath;
    }

    return $assetsFolderLocalPath;
}

function getExternalStylesName($projectSettings) {
    if(!isset($projectSettings->externalStylesName) && !isset($projectSettings->sharedStyleName)) {
        return null;
    }

    if(isset($projectSettings->externalAssetsFolder)) {
        if(isset($projectSettings->externalStylesName)) {
            return $projectSettings->externalStylesName;
        }
    } else if(isset($projectSettings->sharedAssetsFolder)) {
        if(isset($projectSettings->sharedStyleName)) {
            return $projectSettings->sharedStyleName;
        }
    }

    return null;

}

function getLevelAssetsFolder($projectPackageJson) {

    $defaultPath = "production/project/products";

    if (!isset($projectPackageJson->levelAssetsFolder)) {
        return PROJECT_PATH . $defaultPath;
    }

    $levelAssetsFolder = $projectPackageJson->levelAssetsFolder;

    if (isWeb($levelAssetsFolder)) {
        return $levelAssetsFolder;
    }

    $levelAssetsFolderLocalPath = realpath(__DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . $levelAssetsFolder);

    if (!file_exists($levelAssetsFolderLocalPath)) {
        return PROJECT_PATH . $defaultPath;
    }

    return PROJECT_PATH . $levelAssetsFolder;
}

function isWeb($url) {
    return preg_match("~^(?:f|ht)tps?://~i", $url);
}

function getFileUri($fileName) {
	$realPathFileName = realpath($fileName);
	$outputPathFileName = '';

	if(strpos($realPathFileName, '\\')) {
		$outputPathFileName = '/' . str_replace("\\", "/", substr($realPathFileName, 3));
	} else {
		$outputPathFileName = $realPathFileName;
	}

	return ($outputPathFileName);
}

function setUrlQueryParameters() {
    /*
       projectSetting parameters:

       "mobileDragDrop": "y/n",
       "dropDownListOutput": "y/n",
       "stickyWordPools": "y/n",
       "wordBoxPosition": "top/bottom/default",
        "disableOpenGradableTeacherComments": "y/n"
        "collapsibleWordBox": "y/n" (default n)
        "rcfAsMonoRepo": 'y/n' (default n) - forces viewer to try and load everything from rcf folder (production folder included !)
        "useTransformCache": 'y/n' (default y if rcfAsMonoRepo is 'n', otherwise 'n') - should use `rcfAsMonoRepo=y&useTransformCache=y` for automation tests
        "penaliseWrongAnswers": 'y/n' (default n) - penalise wrong answer with -1 when wrong answer given

       should be able to override these default with querystring parameters of the same name

   */
    foreach(array("mobileDragDrop", "dropDownListOutput", "stickyWordPools", "wordBoxPosition", "fixedWordPools", "disableOpenGradableTeacherComments", "collapsibleWordBox", "rcfAsMonoRepo", "useTransformCache", "penaliseWrongAnswers", "useInlineSvg") as $queryParameterName) {
        // if query param set then create a session parameter with the name / value
        if(isset($_GET[$queryParameterName])) {
            logError('[QUERYPARAM] - got parameter [ ' . $queryParameterName . ']');
            $_SESSION[$queryParameterName] = $_GET[$queryParameterName];
        } else {
            // otherwise, clear down any existing session parameter / value
            unset($_SESSION[$queryParameterName]);
        }
    }
}

function getPresentationElementsWithReferenceIds($xmlDoc) {
    // reference content stuff
    $xpath = new DOMXPath($xmlDoc);

    // get all the <presentation> nodes that have a referenceId attribute
    $xquery = '//presentation[not(@referenceId="")]';
    $nodes = $xpath->query($xquery);

    return $nodes;
}

function replacePresentationNodesWithReferenceContent($xmlDoc, $presentationNodesWithReferenceContent, $levelName) {
    foreach ($presentationNodesWithReferenceContent as $presentationNode) {
        $referenceId = $presentationNode->getAttribute('referenceId');
        if(!empty($referenceId)) {

            // load the reference file with the id
            $referenceContentFileName = LEVEL_ASSETS_URL . '/' . $levelName . '/referenceContent/' . $referenceId . '.xml';

            // load the reference content file into a dom
            $referenceContentDoc = XmlDomDocumentFactory::getFromFile($referenceContentFileName);

            // import the reference content node into the main xml document
            $referenceContentNode = $xmlDoc->importNode($referenceContentDoc->documentElement, true);

            // remove all the child nodes from the current presentation node
            while($presentationNode->hasChildNodes()) {
                $presentationNode->removeChild($presentationNode->firstChild);
            }

            $presentationNode->appendChild($referenceContentNode);
        }
    }
}

function runningRcfMonoRepo() {
	$rcfPackageJsonContents = file_get_contents('../package.json');
	$rcfPackageJson = json_decode($rcfPackageJsonContents);

	if(property_exists($rcfPackageJson, 'description')) {
		$packageJsonDescription = $rcfPackageJson->description;
	} else {
		$packageJsonDescription = '';
	}

	return $packageJsonDescription == "RCF Source";
}

?>

