<?php
/* TOC api */
$app->get("/toc", function() use($app) {
    // //
    $app->response()->header("Content-Type", "application/json");
    //
    $results = getRootPathContents($app);
    $app->response()->setBody($results);
});

/*
    new end point for the mass-player to get a keyed object
    of the TOC structure

    eg

        "L0/U01/AS01/A01": {
        "id": "4757677a45564fd5999da4b3bb3eab72",
        "pointsAvailable": "0",
        "teacherPointsAvailable": "0",
        "availablePoints": "0",
        "activityMode": "",
        "gradable": "non-gradable",
        "type": "activity",
        "title": "Styling check for mobile / desktop styles"
    },
    "L0/U02/S01/AS01/A01": {
        etc ....
*/
$app->get("/toc/mass-player", function() use($app) {
    // //
    $app->response()->header("Content-Type", "application/json");
    //
    $start = microtime(true);
    logError("Getting the mass player TOC");
    $results = ActivityStore::getTocStructure();
    $end = microtime(true);
    logError("Got the mass player TOC in " . ($end - $start) . " seconds");

    $app->response()->setBody($results);
});

$app->get("/toc/", function() use($app) {
    // //
    $app->response()->header("Content-Type", "application/json");
    //
    $results = getRootPathContents($app);
    //
    $app->response()->setBody($results);
});

$app->get("/toc/:path", function($path) use($app) {
    // path is the internal path, eg. L1|U01|AS01|A01
    // replace the '|' with '/'
    $app->response()->header("Content-Type", "application/json");
    //
    $path = str_replace("|", "/", $path);
    $serverPath = getServerPathFromAngularPath($path, true);
    //

    if(!file_exists($serverPath)) {
        $app->halt(404, "Cannot find path");
        return;
    }

    // check if the toc results for this path exist in the cache
    $results = getTocCachedData($serverPath);

    if(!isset($results)) {
        // build the results
        $folder = new ProductionFolder($serverPath);
        $results = $folder->getJSON();
        // save to cache
        setTocCachedData($serverPath, $results);
    }

    $app->response()->setBody( $results );
});

function getRootPathContents($app) {
    //
    $serverPath = CONTENT_URL . "/project/products";

    if(!file_exists($serverPath)) {
        $app->halt(404, "Cannot find TOC path");
        return;
    }

    // we don't cache data for the top level toc call
    $folder = new ProductionFolder($serverPath);
    $results = $folder->getJSON();
    return $results;
}
