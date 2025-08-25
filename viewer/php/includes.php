<?php

// include the utils
require_once('lib.php');

// determine if we are running in rcf-source as a developer / monorepo
define('RCF_PATH', '../');

$rcfPackageJsonContents = file_get_contents(RCF_PATH . 'package.json');
$rcfPackageJson = json_decode($rcfPackageJsonContents);

// determine if we are using inline svgs - should always be 'y' unless we force it to 'n'
$useInlineSvg = isset($_GET['useInlineSvg']) && $_GET['useInlineSvg'] === 'y' ? 'y' : 'n';

// determine rcfMonoRepo usage from the package.json file
$usingRcfAsMonoRepo = runningRcfMonorepo();

// determine if we are using the transformation cache - should always use, unless running as monorepo
$useTransformCache = 'y';

if($usingRcfAsMonoRepo) {
	$useTransformCache = isset($_GET['useTransformCache']) ? $_GET['useTransformCache'] : (isset($_SESSION['useTransformCache']) ? $_SESSION['useTransformCache'] : 'y');
}

logError('[PARAMS] - running as monorepo : ' . $usingRcfAsMonoRepo);
logError('[PARAMS] - using transform cache : ' . $useTransformCache);
logError('[PARAMS] - use inline svg : ' . $useInlineSvg);

$useProjectPath = $usingRcfAsMonoRepo ? '../' : '../../';

logError("[PARAMS] - project path : " . $useProjectPath . " - running as monorepo : " . $usingRcfAsMonoRepo);

// define the paths
define('XSL_PATH', RCF_PATH);
define('XSD_PATH', '../xsd');

// if we are running as mono repo then we should be using the rcf-source folder as project path ('../') otherwise the parent/parent folder
define('PROJECT_PATH', $useProjectPath);

// get the project JSON
$projectPackageJsonContents = file_get_contents(PROJECT_PATH . 'package.json');
$projectPackageJson = json_decode($projectPackageJsonContents);

// setup variables used in the transformation + caching
define('RCF_VERSION', $rcfPackageJson->version);
define('RCF_FILE_CACHE', './cache/');
define('RCF_CACHE_STRUCTURE', RCF_FILE_CACHE . 'cache-structure.txt');
define('RCF_CACHE_DETECTOR', RCF_FILE_CACHE . 'cache-details.txt');
define('RCF_SEARCHABLE_FILES', RCF_FILE_CACHE . 'searchable-files.txt');

// get the media-query min width settings (if they aren't defined, use some sensible default values)
$mq768 = getProjectSetting($projectPackageJson, 'minWidth768', '1000px');
$mq1024 = getProjectSetting($projectPackageJson, 'minWidth1024', '1425px');

// define the PHP constants
define('PROJECT_TYPEKIT_ID', getProjectSetting($projectPackageJson, 'typeKitId', ''));
define('CDN_PROJECT_NAME', $projectPackageJson->projectSettings->projectName);
define('CDN_PROJECT_VERSION', $projectPackageJson->version);

// use a more realistic cache name - should be valid for all projects now, rather than
// having to enforce a refresh!
$useCacheName = $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF'];
$useCacheName = substr($useCacheName, 0, strpos($useCacheName, '.php') + 4);

define('CACHE_NAME', $useCacheName);

// used in PHP to write the media query to the '<link>' loading the css
define('MEDIAQUERY_768', $mq768);
define('MEDIAQUERY_1024', $mq1024);

$projectCss = CDN_PROJECT_NAME . '.css';
$projectCss768 = CDN_PROJECT_NAME . '_768.css';
$projectCss1024 = CDN_PROJECT_NAME . '_1024.css';

define('PROJECT_CSS', $projectCss);
define('PROJECT_CSS_768', $projectCss768);
define('PROJECT_CSS_1024', $projectCss1024);

// location of the CDN used for the viewer
define('CONTENT_URL', PROJECT_PATH . $projectPackageJson->projectSettings->productionFolder);

define('LEVEL_ASSETS_URL', getLevelAssetsFolder($projectPackageJson->projectSettings));

// location of the RCF Code in the viewer
// NOTE!!!!!!!! THIS ('../') IS REPLACED WITH '../' AT WEBPACK BUILD TIME IN `buildNonWebpackFiles.js` for the viewer (and non-rcf-source-monorepo projects)
define('RCF_URL', '../');

// location of the remote shared assets
define('EXTERNAL_ASSETS_FOLDER', getExternalAssetsFolder($projectPackageJson->projectSettings));

$externalStylesName = getExternalStylesName($projectPackageJson->projectSettings);

if(isSet($externalStylesName)) {
	define('EXTERNAL_STYLES_NAME', $externalStylesName . '.css');
	define('EXTERNAL_STYLES_NAME_768', $externalStylesName . '_768.css');
	define('EXTERNAL_STYLES_NAME_1024', $externalStylesName . '_1024.css');
}

// XSL Stylesheet to use for generating the Activity HTML
define('XSL_ACTIVITY', XSL_PATH . $projectPackageJson->projectSettings->xsl->generateHTML);
// XSL Stylesheet to use for generating the JSON object
define('XSL_JSON', XSL_PATH . $projectPackageJson->projectSettings->xsl->generateJSON);
// XSL Stylesheet to use for reference objects
define('XSL_REFERENCE', XSL_PATH . $projectPackageJson->projectSettings->xsl->generateReferenceContent);
// XSL Stylesheet to display metadata
define('XSL_METADATA', XSL_PATH . $projectPackageJson->projectSettings->xsl->generateMetaData);

// XSL Stylesheet to display items
$itemsXsl = isset($projectPackageJson->projectSettings->xsl->itemsXsl) ? $projectPackageJson->projectSettings->xsl->itemsXsl : 'xsl/create_rcf_activity.xsl';

$itemsTocXsl = isset($projectPackageJson->projectSettings->xsl->itemsTocXsl) ? $projectPackageJson->projectSettings->xsl->itemsTocXsl : 'xsl/create_items_toc.xsl';

// XSL for decorating activity xml
define('XSL_DECORATE', XSL_PATH . 'xsl/decorate-activity-for-print-generation.xsl');
// XSL for print generation
define('XSL_PRINT', XSL_PATH . 'xsl/create_rcf_print.xsl');


define('XSL_ITEMS', XSL_PATH . $itemsXsl);
define('XSL_ITEMS_TOC', XSL_PATH . $itemsTocXsl);

// XSD Locations for validation
define('XSD_ACTIVITY', RCF_PATH . $projectPackageJson->projectSettings->xsd->activity);
define('XSD_REFERENCE', RCF_PATH . $projectPackageJson->projectSettings->xsd->referenceContent);

$itemsSchema = isset($projectPackageJson->projectSettings->xsd->itemsSchema) ? $projectPackageJson->projectSettings->xsd->itemsSchema : 'xsd/rcf_activity_items.xsd';
define('XSD_ITEMS', RCF_PATH . $itemsSchema);

// RIPPLE Buttons enabled
define('RIPPLE_BUTTONS', getProjectSetting($projectPackageJson, 'useRippleButtons', 'n'));

// MOBILE Drag Drop override / fallback
define('MOBILE_DRAGDROP', getProjectSetting($projectPackageJson, 'mobileDragDrop', 'n'));

// wordbox position override
define('WORDBOX_POSITION', getProjectSetting($projectPackageJson, 'wordBoxPosition', NULL));

// projectType
define('PROJECT_TYPE', getProjectSetting($projectPackageJson, 'projectType', ''));

// dropDownListOutput override - but only if projectType is 'pbf'... sigh
define('DROPDOWN_LIST_OUTPUT', getProjectSetting($projectPackageJson, 'dropDownListOutput', NULL));

// sticky wordpools project setting - can be overridden in the activity element
define('STICKY_WORDPOOLS', getProjectSetting($projectPackageJson, 'stickyWordPools', 'n'));

// fixed wordpools project setting - overrides 'sticky wordpools' if set
define('FIXED_WORDPOOLS', getProjectSetting($projectPackageJson, 'fixedWordPools', 'n'));

// Disable opengradable teacher comments
define('DISABLE_OPENGRADABLE_TEACHER_COMMENTS', getProjectSetting($projectPackageJson, 'disableOpenGradableTeacherComments', 'n'));

// collapsible wordbox
define('COLLAPSIBLE_WORDBOX', getProjectSetting($projectPackageJson, 'collapsibleWordBox', 'n'));

// penalise wrong answers
define('PENALISE_WRONG_ANSWERS', getProjectSetting($projectPackageJson, 'penaliseWrongAnswers', 'n'));

// use inline svg (only to mock the rcf-transformation-server environment
define('USE_INLINE_SVG', $useInlineSvg);

// should we use the transform cache ? (when run as mono repo, default to 'n' unless overridden, not run as mono repo = default true)
define('USE_TRANSFORM_CACHE', $useTransformCache);

require_once('fileCache.php');
