<?php

require_once("includes.php");

/**
 * Transformable object
 *
 * defines to an object which can be transformed from xml into HTML
 *
 * 	- activity (from xml to html)
 * 	- referenceContent (from xml to html)
 *
 */
abstract class TransformableObject {
	//
	protected $id;
	protected $fileName;
	protected $schema;
	protected $xslTemplateHTML;
	protected $xslDecorate;
	protected $xslPrintHTML;

	//
	// called with /production/project/blah/blah/<id>.xml
	function __construct($fileName) {
		//
		$this->id = str_replace(".xml", "", basename($fileName));
		//
		$this->fileName = $fileName;
		$this->xslTemplateHTML = XSL_ACTIVITY; // default
		$this->xslDecorate = XSL_DECORATE;
		$this->xslPrintHTML = XSL_PRINT;
	}

	public function getID() {
		//
		return $this->id;
	}

	public function getFileName() {
		//
		return $this->fileName;
	}

	public function getHTML($editing) {

		// get session values to override package.json values
		$environment = ( isset($_SESSION['environment']) ? $_SESSION['environment'] : '');
		$mobileDragDrop = ( isset($_SESSION['mobileDragDrop']) ? $_SESSION['mobileDragDrop'] : MOBILE_DRAGDROP );
		$dropDownListOutput = ( isset($_SESSION['dropDownListOutput']) ? $_SESSION['dropDownListOutput'] : DROPDOWN_LIST_OUTPUT );
		$stickyWordPools = ( isset($_SESSION['stickyWordPools']) ? $_SESSION['stickyWordPools'] : STICKY_WORDPOOLS );
		$wordBoxPosition = ( isset($_SESSION['wordBoxPosition']) ? $_SESSION['wordBoxPosition'] : WORDBOX_POSITION );
		$fixedWordPools = ( isset($_SESSION['fixedWordPools']) ? $_SESSION['fixedWordPools'] : FIXED_WORDPOOLS );
		$disableOpenGradableTeacherComments = ( isset($_SESSION['disableOpenGradableTeacherComments']) ? $_SESSION['disableOpenGradableTeacherComments'] : DISABLE_OPENGRADABLE_TEACHER_COMMENTS);
		$collapsibleWordBox = ( isset($_SESSION['collapsibleWordBox']) ? $_SESSION['collapsibleWordBox'] : COLLAPSIBLE_WORDBOX );
		$penaliseWrongAnswers = ( isset($_SESSION['penaliseWrongAnswers']) ? $_SESSION['penaliseWrongAnswers'] : PENALISE_WRONG_ANSWERS );
		$useInlineSvg = (isset($_SESSION['useInlineSvg']) ? $_SESSION['useInlineSvg'] : USE_INLINE_SVG);

		$md5ActivityXml = md5_file($this->fileName);
		$md5ItemsXml = '';
		$itemsFileName = str_replace(".xml", ".items", $this->fileName);
		$hasItemsFile = file_exists($itemsFileName);
		if($hasItemsFile) {
			$md5ItemsXml = md5_file($itemsFileName);
		}

		if(USE_TRANSFORM_CACHE == 'y') {
			$md5FileName = RCF_FILE_CACHE . md5($environment . $mobileDragDrop . $dropDownListOutput . $stickyWordPools . $wordBoxPosition . $fixedWordPools . $disableOpenGradableTeacherComments . $collapsibleWordBox . $penaliseWrongAnswers . '-' . $md5ActivityXml . '-' . $md5ItemsXml . '-' . $editing);

			if(file_exists($md5FileName)) {
				logError("[FILE-CACHE] : Returning cached contents for [" . $this->fileName . "] : " . $md5FileName);
				return file_get_contents($md5FileName);
			}
		} else {
			logError('[FILE-CACHE] : USE_TRANSFORM_CACHE is set to "n" - will not cache files associated with ' . $this->fileName);
		}

		// calculate the level name from the filename of this xml file

		$levelName = getLevelFromFileName($this->fileName);

		// calculate the level assets url to be used in the transformation process
		$levelAssetsURL = LEVEL_ASSETS_URL .'/'. $levelName . '/assets';

		// calculate the shared assets url to be used in the transformation process
		$sharedAssetsURL = EXTERNAL_ASSETS_FOLDER . '/assets';

		// build an xml dom document from the activity xml
		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);

		// get any <presentation> elements with a 'referenceId' attribute
		$presentationNodesWithReferenceContent = getPresentationElementsWithReferenceIds($xmlDoc);

		replacePresentationNodesWithReferenceContent($xmlDoc, $presentationNodesWithReferenceContent, $levelName);

		// get the xsltprocessor from the factory/cache
		$proc = XsltFactory::get($this->xslTemplateHTML);

		// pass in the levelAssetsUrl so that the generated HTML can display images from <image src="llama.jpg"> and <audio><track src="llama.mp3"/></audio> elements etc
		$proc->setParameter("", "levelAssetsURL", $levelAssetsURL);

		// pass in the sharedAssetsURL so that anything needing the path can use it
		$proc->setParameter("", "sharedAssetsURL", $sharedAssetsURL);

		$svgFilePathName = realpath($levelAssetsURL . '/images/');

		$useSvgFilePathName = getFileUri($svgFilePathName);

		$proc->setParameter("", "svgFilePath", $useSvgFilePathName);

		// pass in the level name as this will be used in building paths to images / audio
		$proc->setParameter("", "levelName", $levelName);

		// rcfVersion passed in, just for completeness
		$proc->setParameter("", "rcfVersion", RCF_VERSION);

		// calculate / grab the pseudoID for those times it might be necessary
		$pseudoID = getAngularlink($this->fileName, basename($this->fileName));
		$proc->setParameter("", "pseudoID", CDN_PROJECT_NAME . "_" . str_replace("/", "", $pseudoID));

		// use rippleButtons in the output ?
		$proc->setParameter("", "alwaysUseRippleButtons", RIPPLE_BUTTONS);

		// set authoring parameter
		$proc->setParameter("", "authoring", $editing);

		// set mobile drag drop parameter

		$proc->setParameter("", "mobileDragDrop", $mobileDragDrop);

		if (null !== $wordBoxPosition) {
			$proc->setParameter("", "projectWordBoxPosition", $wordBoxPosition);
		}

		if (null !== $dropDownListOutput) {
			$proc->setParameter("", "dropDownListOutput", $dropDownListOutput);
		}

		if (null !== $stickyWordPools) {
			$proc->setParameter("", "stickyWordPools", $stickyWordPools);
		}

		if (null !== $fixedWordPools) {
			$proc->setParameter("", "fixedWordPools", $fixedWordPools);
		}

		if (isset($_SESSION["environment"])) {
			$proc->setParameter("", "environment", $_SESSION["environment"]);
		}

		if (null !== $disableOpenGradableTeacherComments) {
			$proc->setParameter("", "disableOpenGradableTeacherComments", $disableOpenGradableTeacherComments);
		}

		if (null !== $collapsibleWordBox) {
			$proc->setParameter("", "collapsibleWordBox", $collapsibleWordBox);
		}

		if (null !== $penaliseWrongAnswers) {
			$proc->setParameter("", "penaliseWrongAnswers", $penaliseWrongAnswers);
		}

		if (null !== $useInlineSvg && $useInlineSvg !== '') {
			$proc->setParameter("", "useInlineSvg", $useInlineSvg);
		}

		// check if there is an associated '.items' file to go with this xml file
		// if there is, get the full path/name of the file and pass it as a parameter to the transformation
		$itemsFileName = str_replace(".xml", ".items", $this->fileName);
		if(file_exists($itemsFileName)) {
			$realPathFileName = realpath($itemsFileName);
			if(strpos($realPathFileName, '\\')) {
				$useFileName = "/" . str_replace("\\", "/", substr($realPathFileName, 3));
			} else {
				$useFileName = $realPathFileName;
			}
			$proc->setParameter("", "itemsFileName", 'file://' . $useFileName );
		}

		// transform the content !
		$transformedContent = $proc->transformToXML( $xmlDoc );
		if($transformedContent===FALSE) {
			$errors = libxml_get_errors();
			foreach($errors as $error) {
				logError("Error transforming ! line $error->line, columng $error->column\n$error->message");
				$transformedContent .= "<h2>Error on line $error->line, column $error->column</h2><h3>$error->code : $error->message</h3>";
			}
		}

		if(USE_TRANSFORM_CACHE=='y') {
			logError("[FILE-CACHE] : Writing file " . $md5FileName);
			file_put_contents($md5FileName, $transformedContent);
		}

		// return it !
		return $transformedContent;
	}

	public function getPrintHTML() {
		$environment = ( isset($_SESSION['environment']) ? $_SESSION['environment'] : '');
		$mobileDragDrop = ( isset($_SESSION['mobileDragDrop']) ? $_SESSION['mobileDragDrop'] : MOBILE_DRAGDROP );
		$dropDownListOutput = ( isset($_SESSION['dropDownListOutput']) ? $_SESSION['dropDownListOutput'] : DROPDOWN_LIST_OUTPUT );
		$stickyWordPools = ( isset($_SESSION['stickyWordPools']) ? $_SESSION['stickyWordPools'] : STICKY_WORDPOOLS );
		$wordBoxPosition = ( isset($_SESSION['wordBoxPosition']) ? $_SESSION['wordBoxPosition'] : WORDBOX_POSITION );
		$fixedWordPools = ( isset($_SESSION['fixedWordPools']) ? $_SESSION['fixedWordPools'] : FIXED_WORDPOOLS );
		$disableOpenGradableTeacherComments = ( isset($_SESSION['disableOpenGradableTeacherComments']) ? $_SESSION['disableOpenGradableTeacherComments'] : DISABLE_OPENGRADABLE_TEACHER_COMMENTS);
		$collapsibleWordBox = ( isset($_SESSION['collapsibleWordBox']) ? $_SESSION['collapsibleWordBox'] : COLLAPSIBLE_WORDBOX );
		$penaliseWrongAnswers = ( isset($_SESSION['penaliseWrongAnswers']) ? $_SESSION['penaliseWrongAnswers'] : PENALISE_WRONG_ANSWERS );

		$md5ActivityXml = md5_file($this->fileName);
		$md5ItemsXml = '';
		$itemsFileName = str_replace(".xml", ".items", $this->fileName);
		$hasItemsFile = file_exists($itemsFileName);

		if($hasItemsFile) {
			$md5ItemsXml = md5_file($itemsFileName);
		}

		// calculate the absolute url of the cwd
		$absoluteCwd = str_replace($_SERVER['DOCUMENT_ROOT'], '' , getcwd()) . '/';

		// calculate the level name from the filename of this xml file
		$levelName = getLevelFromFileName($this->fileName);

		// calculate the level assets url to be used in the transformation process
        $levelAssetsURL = $absoluteCwd . LEVEL_ASSETS_URL .'/'. $levelName . '/assets';

		// calculate the shared assets url to be used in the transformation process
		$sharedAssetsURL = $absoluteCwd . EXTERNAL_ASSETS_FOLDER . '/assets';

		// get the two stylesheets for the transformation
		$decorateXslt = XsltFactory::get(XSL_DECORATE);
		$printXslt = XsltFactory::get(XSL_PRINT);

		$printXslt->setParameter("", "levelAssetsURL", $levelAssetsURL);
		$printXslt->setParameter("", "sharedAssetsURL", $sharedAssetsURL);
		$printXslt->setParameter("", "seed", (time() % 86400) );
		$printXslt->setParameter("", "printCssURL", $absoluteCwd . RCF_URL . 'build/style/rcf_print.css');
		$printXslt->setParameter("", "javascriptRuntimePath", $absoluteCwd . RCF_URL . 'build/js/rcf.print-runtime.min.js');

		// pass in the level name as this will be used in building paths to images / audio
		$printXslt->setParameter("", "levelName", $levelName);

		// rcfVersion passed in, just for completeness
		$printXslt->setParameter("", "rcfVersion", RCF_VERSION);

		if (isset($_SESSION["environment"])) {
			$printXslt->setParameter("", "environment", $_SESSION["environment"]);
		}

		// build an xml dom document from the activity xml
		$activityDoc = XmlDomDocumentFactory::getFromFile($this->fileName);

		// get any <presentation> elements with a 'referenceId' attribute
		$presentationNodesWithReferenceContent = getPresentationElementsWithReferenceIds($activityDoc);

		// replace any presentation nodes with reference ids with the content from the reference file
		replacePresentationNodesWithReferenceContent($activityDoc, $presentationNodesWithReferenceContent, $levelName);


		// decorate the activity xml using the stylesheet
		$decoratedDoc = $decorateXslt->transformToDoc($activityDoc);
		// build the print html using the stylesheet
		$printHtmlOutput = $printXslt->transformToXML($decoratedDoc);

		return $printHtmlOutput;

	}

	public function getXML() {
		//
		$xmlDom = XmlDomDocumentFactory::getFromFile($this->fileName);

		// MAMP version of php gets upset unless we do it this way ....
		// ¯\_(ツ)_/¯
		$documentElement = $xmlDom->documentElement;
		$savedXml = $xmlDom->saveXML($documentElement);
		return $savedXml;
	}

	public function setXML($xml) {
		// need to validate the xml before we save it !
		// - will raise a 'verifyexception' if there's an issue with the xml
		$xml = $this->verifyXML($xml);
		file_put_contents($this->fileName, $xml, LOCK_EX);
	}

	public function verifyXML($xml) {

		$xmlDoc = XmlDomDocumentFactory::getFromString($xml);
		// now add the ID back into the Activity Node ! just in case anyone has updated it by accident
		$rootNode = $xmlDoc->documentElement;

		if($rootNode && $rootNode->nodeName=="activity") {
			$usedID = $rootNode->getAttribute("id");
			$rootNode->setAttribute("id", str_replace(".xml", "", basename($this->fileName)));
		}

		// now test the xml against the schema
		if(!file_exists($this->schema)) {
			throw VerifyException("The schema does not exist ! [$this->schema]");
		}

		if (!$xmlDoc->schemaValidate($this->schema)) {
			$errors = libxml_get_errors();

			$errArray = array();
			$message = '';
			foreach($errors as $error) {
				array_push($errArray, array("line"=>$error->line, "column"=>$error->column, "description"=>$error->code . " : " . $error->message));
			}
 			libxml_clear_errors();

			throw new VerifyException("Error validating Activity against schema [$this->schema] !", 98, null, $errArray);

	    }
	    // expanding the code here as MAMP gets funny when you
		// try to do $xmlDoc->saveXML($xmlDoc->documentElement)
		// ... no idea why - but this fixes it !
		$documentElement = $xmlDoc->documentElement;
	    return $xmlDoc->saveXML($documentElement);
	}

	public function getReferenceContentIds() {
		$xmlDoc = XmlDomDocumentFactory::getFromFile($this->fileName);
		$nodes = getPresentationElementsWithReferenceIds($xmlDoc);
		$ids = array();
		foreach($nodes as $node) {
			$ids[] = $node->getAttribute("referenceId");
		}

		return $ids;
	}

	//
	public function getBreadCrumbs() {
		$parent = dirname($this->fileName);
		$tocFolder = new ProductionFolder($parent);
		$bc = $tocFolder->getBreadCrumbs();
		return $bc;
	}
	//
}
?>
