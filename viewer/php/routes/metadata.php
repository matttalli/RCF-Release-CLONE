<?php
$app->get("/metadata/:path", function($path) use($app) {
    //
    $app->response()->header("Content-Type", "application/json");
    // get metadata json
    $path = str_replace("|", "/", $path);
    $path = CONTENT_URL . "/project/products/" . $path . "/metadata.xml";
    //
    try {
        $metaDataObject = new MetaData($path);
        $metadata = $metaDataObject->getJSON();
        $app->response()->setBody($metadata);
    } catch(Exception $ex) {
        logError("Error getting metadata !");
        $app->halt(404, $ex->getMessage());
    }
});

$app->post("/metadata/:path", function($path) use($app) {
    //
    $app->response()->header("Content-Type", "application/json");
    // save metadata
    $path = str_replace("|", "/", $path);
    $serverPath = CONTENT_URL . "/project/products/" . $path . "/metadata.xml";

    if(!file_exists($serverPath)) {
        $app->halt(404, "No metadata found at this location !");
        return;
    }

    $request = $app->request();
    $metaData = json_decode($request->getBody());
    if($metaData==null) {
        $app->halt(404, "No metadata found !");
        return;
    }
    $metaDataObject = new MetaData($serverPath);
    $metaDataObject->setJSON($metaData);

    $pathParts = explode(DIRECTORY_SEPARATOR, $path);
    $lastPart = array_pop($pathParts);
    if(strpos($lastPart, 'Level_')===0) {
        $path = $path . DIRECTORY_SEPARATOR . "content";
    }

    removeTocCachedData(CONTENT_URL . "/project/products/" . $path);

    $app->response()->setBody(json_encode($metaData));

});

$app->get("/metadataXml/:path", function($path) use($app) {

    // get metadata xml
    $path = str_replace("|", "/", $path);
    $path = CONTENT_URL . "/project/products/" . $path . "/metadata.xml";

    try {
        $app->response()->header("Content-Type", "application/xml");
        $metaDataObject = new MetaData($path);
        $app->response()->setBody($metaDataObject->getXml());
    }   catch(Exception $ex) {
        $app->response()->header("Content-Type", "text/html");
        logError("Error getting metadata !");
        $app->halt(404, $ex->getMessage());
    }
});

$app->post("/metadataXml/:path", function($path) use($app) {
    //
    $app->response()->header("Content-Type", "application/json");

    // save metadata
    $path = str_replace("|", "/", $path);
    $serverPath = CONTENT_URL . "/project/products/" . $path;
    $extraKey = "-path-toc-metadata";

    $path = CONTENT_URL . "/project/products/" . $path . "/metadata.xml";

    if(!file_exists($path)) {
        $app->halt(404, "No metadata found at this location !");
        return;
    }

    $request = $app->request();
    $metaData = $request->getBody();

    if($metaData==null) {
        $app->halt(404, "No metadata found !");
        return;
    }

    $metaDataObject = new MetaData($path);
    $metaDataObject->saveXml($metaData);

    removeTocCachedData($serverPath);

});
