<?php
$app->get("/level/:level/images", function ($level) use ($app) {
    $app->response()->header("Content-Type", "application/json");
    // return list of images for the level
    $imagesPath = LEVEL_ASSETS_URL . '/' . "Level_" . $level . "/assets/images";

    $imageFiles = glob($imagesPath . "/*.*", GLOB_NOSORT);
    natsort($imageFiles);

    $results = array();

    foreach ($imageFiles as $imageFile) {
        array_push($results, array("name" => basename($imageFile)));
    }

    $browserResults = json_encode($results);
    $app->response()->setBody($browserResults);
});

$app->get("/level/:level/html", function ($level) use ($app) {
    $app->response()->header("Content-Type", "application/json");
    // get all files from {$level}/assets/html in json
    $path = getServerPathFromAngularPath("L" . $level);
    $path = str_replace("content", "assets/html", $path);

    $app->response()->setBody($path);
});

$app->get("/level/:level/html/:filename", function ($level, $htmlFile) use ($app) {
    $app->response()->header("Content-Type", "text/html");
    $path = getServerPathFromAngularPath("L" . $level);
    $path = str_replace("content", "assets/html/", $path);
    $path .= $htmlFile;

    $app->response()->setBody(file_get_contents($path));
});
