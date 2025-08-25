<?php
$app->get("/test/:angularPath", function($angularPath) use($app) {
    $angularPath = str_replace("|", "/", $angularPath);
    echo getServerPathFromAngularPath($angularPath);
});
