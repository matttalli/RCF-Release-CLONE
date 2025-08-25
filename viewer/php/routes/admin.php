<?php
$app->get("/admin", function() use ($app) {
    // return json array of admin settings
    $app->response()->header("Content-Type", "application/json");
    //
    $jsonAdmin = null;
    if(!file_exists("admin.json")) {
        $jsonAdmin = array("enableSave"=>"y");
        $jsonAdmin = json_encode($jsonAdmin);
    } else {
        $jsonAdmin = file_get_contents("admin.json");
    }
    $app->response()->setBody($jsonAdmin);
});

$app->post("/admin", function() use($app) {
    $app->response()->header("Content-Type", "application/json");
    //
    $request = $app->request();
    $adminData = json_decode($request->getBody());
    if($adminData==null) {
        $app->halt(404, "No admin information sent !");
        return;
    }
    file_put_contents("admin.json", json_encode($adminData));
});

$app->get("/admin/generateguid", function() use ($app) {
    $app->response()->header("Content-Type", "application/json");

    $app->response()->setBody(json_encode(array("guid"=>getGUID())));
});

$app->get("/admin/rebuild", function() use($app) {
    $app->response()->header("Content-Type", "application/json");
    ActivityStore::getActivityArray(true);
    SearchEngine::getSearchableFiles(true);
    $app->response()->setBody(json_encode(array("status"=>"ok")));
});
