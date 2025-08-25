<?php
require_once("./php/lib.php");

// determine if we are running in rcf-source as a developer / monorepo and where to load the rcf files from
$pathToRcfFiles = runningRcfMonoRepo() ? '../dist/rcf-release' : '..';

?>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>RCF Print Output</title>
		<!-- load the print styles-->
		<link href="<?= $pathToRcfFiles ?>/build/style/rcf_print.css" rel="stylesheet">
		<!-- load the rcf print runtime -->
		<script src="<?= $pathToRcfFiles ?>/build/js/rcf.print-runtime.min.js"></script>
	</head>

	<body>
		<!-- the element to populate with the playlist of activity print html-->
		<ol id="print-contents" class="rcfPrint-applyThemeFont"></ol>

		<!--
			the script to load the playlist of activity print html
			having 'defer' and type="module" will ensure the script is loaded after the body / dom is ready
		-->
		<script defer type="module">

			// get query parameters
			const urlParameters = new URLSearchParams(window.location.search);
			// get playlist parameter (this is the path /L0/U01/AS01 etc
			const playlist = urlParameters.get('playlist');
			const language = urlParameters.get('runtimeLanguage') || undefined;

			(async () => {
				await loadPrintPlaylist(playlist);
			})();

			async function loadPrintPlaylist(playlist) {
				// get the print html for all the activities in the playlist
				try {
					const response = await fetch('api.php/print-playlist/' + playlist);
					const data = await response.json();

					// if there's an error - abort
					if(!Array.isArray(data)) {
						console.log("Error: data from server is not an array ", data);
					} else {
						// otherwise populate the div with the contents from the server
						const printContentsElement = document.getElementById('print-contents');

						data.forEach(printHtml => {
							// create an li container
							const listElement = document.createElement('li');
							// create a <div> print element for the print html
							const printElement = document.createElement('div');
							printElement.innerHTML = printHtml;
							// append the print element to the li container
							listElement.appendChild(printElement);
							// append the li container to the print contents element
							printContentsElement.appendChild(listElement);
						});

						// the rcf print runtime registers itself as a global variable on the
						// 'window' object called `rcfPrintRuntime` with a single method called `initialisePage`
						await rcfPrintRuntime.initialisePage(printContentsElement, language);
					}

				} catch(error) {
					console.error(`Error getting print html for the playlist: ${error}`);
				}
			}

		</script>
	</body>

</html>
