<?php
/* Activity + referenceContent API */
$app->get("/activities", function() use($app) {
    // get json array of all activity ID's in the project
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    //
    $activities = ActivityStore::getActivityIDArray(true);
    if($activities==null) {
        $app->halt(404, "No activities found !");
        return;
    }
    // output the array in json format
    $app->response()->setBody(json_encode($activities));
});

$app->get("/activity/:id", function($id) use($app) {
    // get json representation of activity
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    //
    $activity = ActivityStore::getActivityByID($id);
    if($activity==null) {
        $app->halt(404, "Activity not found");
        return;
    }

    try {
        $app->response()->setBody($activity->getAsJSON("N"));
    } catch(Exception $ex) {
        $app->halt(403, "Error getting activity ! " . $ex->getMessage());
    }
});

$app->get("/activity/:id/html", function($id) use($app) {
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/html");
    //
    $activity = ActivityStore::getActivityByID($id);
    if($activity==null) {
        $app->halt(404, "Activity not found");
        return;
    }
    $app->response()->setBody( $activity->getHTML(false) );
});

$app->get("/activity/:id/json", function($id) use($app) {
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    $activity = ActivityStore::getActivityByID($id);
    if($activity==null) {
        $app->halt(404, "Activity not found");
        return;
    }
    $app->response()->setBody($activity->getJSON());
    return;
});

// Save activity !
$app->put("/activity/:id", function($id) use($app) {
    //
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    // save it (validate first)
    $request = $app->request();

    $activityData = json_decode($request->getBody());

    $activity = ActivityStore::getActivityByID($id);

    if($activity==null) {
        $app->halt(404, "Activity not found");
        return;
    }

    if(property_exists($activityData, "css")) {
        $activity->setCSS($activityData->css);
    }

    if(property_exists($activityData, "css768")) {
        $activity->set768CSS($activityData->css768);
    }

    $activityFileName = $activity->getFileName();
    $activityLocation = dirname($activityFileName);

    removeTocCachedData($activityLocation);

    try {

        if($activity->hasItems() && $activityData->itemsXml) {
            $activityItems = $activity->getItems();
            $newItemsXml = $activityData->itemsXml;
            $activityItems->setXML($newItemsXml);
        }

        $activity->setXML($activityData->xmlContent) ;
        $app->response()->setBody( $activity->getAsJSON('Y') );
    } catch(VerifyException $ve) {
        $app->halt(401, $ve->getErrors());
        return;
    }
});

$app->get("/activity/edit/:id", function($id) use($app) {
    // get json representation of activity
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    //
    $activity = ActivityStore::getActivityByID($id);
    if($activity==null) {
        $app->halt(404, "Activity not found");
        return;
    }
    $app->response()->setBody( $activity->getAsJSON("Y") );
});

$app->get("/activity/path/:path/", function($path) use($app) {
    //
    // path is the internal path, eg. L1|U01|AS01|A01
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    //
    $path = str_replace("|", "/", $path);
    $serverPath = getServerPathFromAngularPath($path);
    //
    $activity = ActivityStore::getActivityByPath($serverPath);
    if($activity==null) {
        logError("Activity not found at $serverPath");
        $app->halt(404, "Activity not found");
        return;
    }
    $results = null;
    try {
        $results = $activity->getAsJSON("N");
    } catch(Exception $ex) {
        $app->halt(403, "Error getting Activity ! " . $ex->getMessage());
        return;
    }
    $app->response()->setBody($results);
});

$app->get("/activity/print/:path+", function($path) use($app) {
    $path = join('/', $path);
    $app->response()->header("Content-Type", "text/html");

    $serverPath = getServerPathFromAngularPath($path);
    if(!file_exists($serverPath)) {
        $results = array(
            "error" => "Activity server path " . $serverPath . " not found."
        );
        $app->response()->setBody(json_encode($results));
        return;
    }

    $activity = ActivityStore::getActivityByPath($serverPath);

    $contents = $activity->getPrintHTML();

    $app->response()->setBody($contents);
});

$app->get("/activity/popup/path/:path+", function($path) use($app) {
    // used in the popup player to get an activity bypassing the cached in the viewer backend

    // $path is an array from the 'L1/U1/AS01/A01' parameters passed in, eg ['L1', 'U1', 'AS01', 'A01']
    $path = join('/', $path);
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");

    $serverPath = getServerPathFromAngularPath($path);

    if(!file_exists($serverPath)) {
        $results = array(
            "error" => "Activity server path " . $serverPath . " not found."
        );
        $app->response()->setBody(json_encode($results));
        return;
    }

    $iterator = new RecursiveDirectoryIterator( $serverPath );
    $xmlFilesInActivityFolder = array();

    foreach(new RecursiveIteratorIterator($iterator) as $file) {
        $fileName = basename($file);
        if(endsWith($fileName, '.xml') && (strlen($fileName) > 30)) {
            $useName = str_replace("\\", "/",  $file->getPathName());
            array_push($xmlFilesInActivityFolder, $useName);
        }
    }

    $serverPath = $xmlFilesInActivityFolder[0];
    $activity = new Activity($serverPath);

    $results = $activity->getAsJSON("N");
    $app->response()->setBody($results);
});


$app->get("/activity/path/edit/:path/", function($path) use($app) {
    //
    // path is the internal path, eg. L1|U01|AS01|A01
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    //
    $path = str_replace("|", "/", $path);
    $serverPath = getServerPathFromAngularPath($path);
    //
    $activity = ActivityStore::getActivityByPath($serverPath);
    if($activity==null) {
        logError("Activity not found at $serverPath");
        $app->halt(404, "Activity not found");
        return;
    }
    $results = null;
    try {
        $results = $activity->getAsJSON("Y");
    } catch(Exception $ex) {
        $app->halt(403, "Error getting Activity ! " . $ex->getMessage());
        return;
    }
    $app->response()->setBody($results);
});

$app->post("/activity/:id/validate", function($id) use($app) {
    //
    $app->response()->header("Access-Control-Allow-Origin", "*");
    $app->response()->header("Content-Type", "application/json");
    // validate it
    $request = \Slim\Slim::getInstance()->request();
    $activityData = json_decode($request->getBody());
    $activity = ActivityStore::getActivityByID($id);
    try {

        if($activity->hasItems() && $activityData->itemsXml) {
            $activityItems = $activity->getItems();
            $newItemsXml = $activityData->itemsXml;
            $activityItems->verifyXML($newItemsXml);
        }

        $activity->verifyXML($activityData->xmlContent);
    } catch(VerifyException $ve) {
        $app->halt(401, $ve->getErrors());
        return;
    }
    $app->response()->setBody(json_encode($activityData));
});
