<?php
if(isset($_GET["id"])) {
	$id = $_GET["id"];
} else {
	$id = "";
}
?>
<html>
	<head>
		<style>
			html, body, div, iframe {
				margin: 0;
				padding: 0;
				border: 0;
				font-size: 100%;
				font: inherit;
				vertical-align: baseline;
			}
			body {

			}
			iframe {
				display: block;
				margin: 0 auto;
				width: 95%;
				height: 95%;
				margin-top: 10px;
			}
		</style>
	</head>
	<body>
		<div class="main">
		<!-- replace src url for the activity url you want to test: https://[PRODUCT_URL]/rcf/viewer/test_activity.php?id=[ACTIVITY_ID]-->
			<iframe src="test_activity.php?id=<?php echo $id ?>"></iframe>
		</div>
	</body>
<!-- ensure the offset is not 0, 0 for testing purposes -->
