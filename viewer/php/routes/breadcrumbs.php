<?php
/* BreadCrumbs */
$app->get("/breadcrumb/:path", function($path) use($app) {
    //
    // path is the internal path, eg. L1|U01|AS01|A01
    $app->response()->header("Content-Type", "application/json");
    //
    $path = str_replace("|", "/", $path);
    $serverPath = getServerPathFromAngularPath($path);
    //
    $tocFolder = new ProductionFolder($serverPath);
    //
    $app->response()->setBody($tocFolder->getBreadCrumbs());
    //
});
