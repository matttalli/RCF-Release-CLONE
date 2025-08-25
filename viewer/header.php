<?php
	/* included PHP header file for including scripts / styles on the main page */

$rootPath = "";

if($viewMode=="source") {
	$rootPath = "../production/rcf";
} else {
	$rootPath = RCF_URL . "build";
}

$rootStylePath = $rootPath . '/style' . '/';
$externalAssetsLocation = EXTERNAL_ASSETS_FOLDER . '/style' . '/';
$projectSharedStyles = CONTENT_URL . '/project' . '/shared' . '/style' . '/';

$mq768 = "only screen and (min-width: " . MEDIAQUERY_768 . ")";
$mq1024 = "only screen and (min-width: " . MEDIAQUERY_1024 . ")";

?>
	<!-- -->
	<script src="<?= $rootPath ?>/jslibs/jquery.min.js"></script>
	<!-- -->
	<link type="text/css" href="<?= $rootStylePath ?>rcf_core.css" rel="stylesheet">

	<!-- 3rd party libraries - these are concatenated into rcf_core.css during the build of the product/project -->
<?php
if($viewMode=="source") {
?>
	<link type="text/css" href="<?= $rootStylePath ?>owl.carousel.css" rel="stylesheet">
	<link type="text/css" href="<?= $rootStylePath ?>owl.theme.css" rel="stylesheet">
	<link type="text/css" href="<?= $rootStylePath ?>magnificpopup.css" rel="stylesheet">
	<link type="text/css" href="<?= $rootStylePath ?>plyr.css" rel="stylesheet">
<?php
}
?>
	<link type="text/css" href="<?= $rootStylePath ?>rcf_768.css" media="<?= $mq768 ?>" rel="stylesheet">
	<link type="text/css" href="<?= $rootStylePath ?>rcf_1024.css" media="<?= $mq1024 ?>" rel="stylesheet">

<?php
if(defined('EXTERNAL_STYLES_NAME')) {
?>
	<link type="text/css" href="<?= $externalAssetsLocation . EXTERNAL_STYLES_NAME ?>" rel="stylesheet">
	<link type="text/css" href="<?= $externalAssetsLocation . EXTERNAL_STYLES_NAME_768 ?>" media="<?= $mq768 ?>"  rel="stylesheet">
	<link type="text/css" href="<?= $externalAssetsLocation . EXTERNAL_STYLES_NAME_1024 ?>" media="<?= $mq1024 ?>"  rel="stylesheet">
<?php
}
?>
	<link type="text/css" href="<?= $projectSharedStyles . PROJECT_CSS ?>" rel="stylesheet">
	<link type="text/css" href="<?= $projectSharedStyles . PROJECT_CSS_768 ?>" media="<?= $mq768 ?>"  rel="stylesheet">
	<link type="text/css" href="<?= $projectSharedStyles . PROJECT_CSS_1024 ?>" media="<?= $mq1024 ?>"  rel="stylesheet">

	<link type="text/css" href="style/toastr.min.css" rel="stylesheet">
	<link type="text/css" href="style/viewer.css" rel="stylesheet">

	<!-- animate css -->
	<link type="text/css" href="style/animate.css" rel="stylesheet" />

<?php
	if(defined( 'PROJECT_FONT')) {
		echo PROJECT_FONT;
	}
?>

	<!-- third party scripts, angular, ace, emmet, toastr etc -->

	<script type="text/javascript" src="compiled/viewer/vendors.min.js?<?= uniqid() ?>"></script>

	<!-- cannot compile ace into a package as it dynamically loads extra files and then doesn't know where they come from ! -->
	<script type="text/javascript" src="js/vendor/ace/ace.js"></script>
	<script type="text/javascript" src="js/vendor/ace/ext-emmet.js"></script>
	<script type="text/javascript" src="js/vendor/emmet.min.js"></script>

	<style>
	/* overridden here */
	/* .desktopViewerMode .prevNext {
		display:inline;
	} */

	</style>

	<!-- ensure that the rcf.min.js file is *always* loaded even if devtools open -->
	<script type="text/javascript" src="<?= RCF_URL ?>build/js/rcf.min.js?<?= uniqid() ?>"></script>
	<script type="text/javascript" src="<?= RCF_URL ?>build/js/rcf.libs.min.js"></script>

	<script>

<?php
/*
	the next line of javascript will tell the php pages to start scanning the filesystem
	for activities and build the internal cache

	This would only (normally !) happen from rcf-source-monorepo, *unless* the
	user has appended '&flush' to the url (which is *NOT* documented)

	starting it this way (with an ajax / fetch call) allows us to build a user interface to
	show the user while it's going on

	Once the call has finished, nothing is returned to the user, but we remove
	the '.loadingProjectStructure' from the <html> element

	*Then* we initialise the angular application
*/
	$waitFor = $flush ? "fetch('api.php/admin/rebuild')" : "Promise.resolve()";
?>
	var waitFor = <?= $waitFor ?>;

	console.log(new Date(), 'loading project structure ... ');
	waitFor.then(function(response) {
		angular.element(document).ready(function() {
			$('html').removeClass('loadingProjectStructure');
			angular.bootstrap(document, ['ViewerApp']);
		});
	}).catch(function(error) {
		alert('Error loading project structure !' + error);
		$('html').removeClass('loadingProjectStructure');
	}).finally(function() {
		console.log(new Date(), 'loaded...');
	});

</script>
