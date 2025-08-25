<?php

/* Gets a property from metadata.xml at a section level */

$app->get('/section/:level/:searchValue', function($level, $searchValue) use ($app) {

    $app->response()->header("Content-Type", "application/json");
    // get metadata json

    $level = str_replace("|", "/", $level);

    $serverPath = (stripos($level, 'Level') === false)? getServerPathFromAngularPath($level) : CONTENT_URL . "/project/products/" . $level;

    $level_r = (explode("/",$serverPath));
    $temp_path = [];

    foreach ($level_r as $sub_path) {

        if(stripos($sub_path, 'section_') !== false) {
            array_push($temp_path, $sub_path);
            break;
        }
        array_push($temp_path, $sub_path);

    }

    $path = join('/', $temp_path);
    $level = $path . "/metadata.xml";

    //
    try {
        $metaDataObject = new MetaData($level);

        $metadata = $metaDataObject->getJSON();
        $meta = (json_decode($metadata));

        $app->response()->setBody(json_encode(array($searchValue=> isset($meta->$searchValue) && !empty($meta->$searchValue)? $meta->$searchValue: 'n')));

    } catch(Exception $ex) {
        logError("Error getting metadata !");
        $app->halt(404, $ex->getMessage());
        return;
    }


});
