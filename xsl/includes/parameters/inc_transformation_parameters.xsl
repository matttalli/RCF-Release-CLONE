<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	*******************************************************************************************
	Parameters passed into the stylesheet - not all are required
	*******************************************************************************************
-->

	<!-- path to activity .items file (if any) -->
	<xsl:param name="itemsFileName"/>

	<!-- file url to use for svg file path -->
	<xsl:param name="svgFilePath"/>

	<!-- URL (absolute or relative) to use to locate shared assets -->
	<xsl:param name="sharedAssetsURL" select="'./shared'"/>

	<!-- URL (absolute or relative) to use to locate level assets -->
	<xsl:param name="levelAssetsURL" select="'./levels'"/>

	<!-- level name (Level_N) to use as a class name in the activity div -->
	<xsl:param name="levelName" select="''"/>

	<!-- internal VIEWER parameter to signify if we are editing xml -->
	<xsl:param name="authoring" select="'N'"/>

	<!-- default pseudoID to use - if missing, xslt will generate one-->
	<xsl:param name="pseudoID" select="''"/>

	<!-- RCF version being used to generate the html-->
	<xsl:param name="rcfVersion"/>

	<!-- Always use the recording button in an audio player y/n -->
	<xsl:param name="alwaysAddRecordingButton" select="'n'"/>

	<!-- Use ripple buttons in the generated activity html -->
	<xsl:param name="alwaysUseRippleButtons" select="'n'"/>

	<!-- Use drag drop on mobiles - should be 'n' for older projects -->
	<xsl:param name="mobileDragDrop" select="'n'"/>

	<!-- wordBoxPosition to override activity value (top/bottom/default/'') -->
	<xsl:param name="projectWordBoxPosition"/>

	<!-- environment value - used by viewer and CAPE - (capePreview/default/'') -->
	<xsl:param name="environment" select="'default'"/>

	<!-- dropDownListOutput to override select elements in generated html (y/n)-->
	<xsl:param name="dropDownListOutput" select="'n'"/>

	<!-- sticky wordpools (y/n) -->
	<xsl:param name="stickyWordPools" select="'n'"/>

	<!-- fixed wordpools, for when they just aren't sticky enough (y/n) -->
	<xsl:param name="fixedWordPools" select="'n'"/>

	<!-- collapsible wordBox (remember, wordBox and wordPool are interchangeable ... sigh ... ) (y/n)-->
	<xsl:param name="collapsibleWordBox" select="'n'"/>

	<!-- disable open gradable teacher comments - only works for *WRITING* at the moment -->
	<xsl:param name="disableOpenGradableTeacherComments" select="'n'"/>

	<!-- penaliseWrongAnswers parameter - just for adding to the activity div - has no other affect on the html ouput (y/n) - default to 'n' if not supplied -->
	<xsl:param name="penaliseWrongAnswers" select="'n'"/>

	<!-- CAPE only parameter ! used by their engine to locate the contractions.xml file -->
	<xsl:param name="engineIdentifier" />

	<!-- CAPE only parameter ! used by their engine to locate other assets -->
	<xsl:param name="host" />

	<!-- rcf-transformation-server parameters -->
	<!--

		useInlineSvg: default 'y'

		'y': will read the svg as part of the transformation process and inject it into the generated html/validate it's structure

		'n': will ...
			1. stop the svg from being injected into the generated html (the rcf-transformation-server doesn't have access to the location)
			2. return an <img class="dev-inline-svg"> in place of the svg
			3. rcf.min.js will detect the <img class="dev-inline-svg"> and then replace it with the svg at runtime
			4. rcf.min.js will then validate the injected svg and if any xml/svg discrepancies, show the same errors as the xslt would
	-->
	<xsl:param name="useInlineSvg" select="'y'"/>

</xsl:stylesheet>
