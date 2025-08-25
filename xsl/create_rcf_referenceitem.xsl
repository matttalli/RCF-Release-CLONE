<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   version="1.0">
<!-- *******************************************************************************************
		create_rcf_v2.xsl

		Chris Eastwood, 2013 for Macmillan Education

		Version 2.0 of the RCF

		- Creates the 'activity' html structure for a 'generic' rcf activity from an xml file
		- each 'template' in here can be overriden by a calling 'project xsl' file
		- eg. if you want to handle 'rubric' elements differently, create you own

			<xsl:template match="rubric" ... />

			- template handler in the projects XSL file
	 *******************************************************************************************
-->
	<xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes"/>

	<!-- include the necessary templates for reference content -->
	<xsl:include href="includes/inc_referencecontent_includes.xsl"/>
	<xsl:include href="includes/interactions/audio/inc_rcf_audioImages.xsl"/>
	<xsl:include href="includes/wordbox/inc_rcf_wordbox_collapsible_controls.xsl"/>


	<!-- tell the processor to strip spaces from all elements...... -->
	<xsl:strip-space elements="*"/>
	<!-- ... except for these ones -->
	<xsl:preserve-space elements="list li item p i b u sup sub strike styled td eSpan eDiv cSpan sSpan colourText locating code"/>

	<!-- *******************************************************************************************
			Parameters passed into the stylesheet - not all are required
		 ******************************************************************************************* -->
	<xsl:include href="includes/parameters/inc_transformation_parameters.xsl"/>

	<!-- *******************************************************************************************
			Variables used in the stylesheet - can be overrided by the project xsl file
		 ******************************************************************************************* -->

	<!-- lower/uppercase variable transformation vals -->
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

 	<xsl:variable name="audio_path"><xsl:value-of select="$levelAssetsURL"/>/audio</xsl:variable>
 	<xsl:variable name="video_path"><xsl:value-of select="$levelAssetsURL"/>/video</xsl:variable>

	<xsl:variable name="wordBoxPosition">
		<xsl:choose>
			<xsl:when test="$projectWordBoxPosition"><xsl:value-of select="$projectWordBoxPosition"/></xsl:when>
			<xsl:when test="/activity[@wordBoxPosition]"><xsl:value-of select="/activity/@wordBoxPosition"/></xsl:when>
			<xsl:otherwise>default</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- global variable for the number of wordpools/wordboxes in the activity -->
	<xsl:variable name="numberOfWordPoolsInActivity"><xsl:call-template name="countStandardInteractionsWithWordBox"/></xsl:variable>

	<!-- global variable to enable/disable fixed wordBoxes -->
	<xsl:variable name="useFixedWordPools">
		<xsl:choose>
			<xsl:when test="$numberOfWordPoolsInActivity &gt; 1">n</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$fixedWordPools='y'">y</xsl:when>
					<xsl:when test="$fixedWordPools='n'">n</xsl:when>
					<xsl:otherwise>n</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- *******************************************************************************************
			TEMPLATE MATCHING
		 ******************************************************************************************* -->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="outputFullRecordingHtml">
		<!-- not for reference content -->
	</xsl:template>

</xsl:stylesheet>
