<?php
$app->get("/activity/find/:level/:searchValue", function($level, $searchValue) use($app) {
    $app->response()->header("Content-Type", "application/json");
    if($level!="all") {
        $level = getLevelFromAbbr($level);
    } else {
        $level = "";
    }
	$results = SearchEngine::searchProductionFolder($level, $searchValue);

    $app->response()->setBody($results);
});
