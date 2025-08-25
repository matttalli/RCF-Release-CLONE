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

	<!-- included templates for activity -->
	<xsl:include href="includes/inc_activity_includes.xsl"/>

	<!-- tell the processor to strip spaces from all elements...... -->
	<xsl:strip-space elements="*"/>
	<!-- ... except for these ones -->
	<xsl:preserve-space elements="list li item p i b u sup sub strike styled td eSpan eDiv cSpan sSpan colourText code clue card matchItem matchTarget prompt description"/>
	<!-- *******************************************************************************************
			Parameters passed into the stylesheet - not all are required
		 ******************************************************************************************* -->
	<xsl:include href="includes/parameters/inc_transformation_parameters.xsl"/>
	<!-- ******************************************o*************************************************
			Variables used in the stylesheet - can be overrided by the project xsl file
		 ******************************************************************************************* -->

	<!-- lower/uppercase variable transformation vals -->
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzñáéíóúü'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÑÁÉÍÓÚÜ'" />

 	<xsl:variable name="audio_path"><xsl:value-of select="$levelAssetsURL"/>/audio</xsl:variable>
 	<xsl:variable name="video_path"><xsl:value-of select="$levelAssetsURL"/>/video</xsl:variable>

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
	<!-- global var (across .items xml too !) for wordBoxPosition -->
	<xsl:variable name="wordBoxPosition">
		<xsl:choose>
			<xsl:when test="$projectWordBoxPosition">
				<xsl:choose>
					<xsl:when test="$useFixedWordPools='y'">bottom</xsl:when>
					<xsl:otherwise><xsl:value-of select="$projectWordBoxPosition"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/activity[@wordBoxPosition]"><xsl:value-of select="/activity/@wordBoxPosition"/></xsl:when>
			<xsl:when test="$useFixedWordPools='y'">bottom</xsl:when>
			<xsl:otherwise>default</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- *******************************************************************************************
			TEMPLATE MATCHING
		 ******************************************************************************************* -->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- *******************************************************************************************

		The following templates are not used in the base RCF stylesheet - the 'project' stylesheets
		can 'override' these and include their own handling for them.

		They *must* reside in this file as the 'create_rcf.xsl' stylesheet *does* call them, even
		though they are 'empty' in the standard stylesheet

		******************************************************************************************* -->
	<xsl:template name="pageTitle" />

	<xsl:template name="innerHeader" />

	<xsl:template match="glossary" />

	<xsl:template name="preHeader" />

	<!-- *******************************************************************************************
			not used in this template - ignore any matches to them
		 ******************************************************************************************* -->
	<xsl:template match="distractors"/>
	<xsl:template match="distractors/item"/>
	<xsl:template match="complexDroppables"/>
	<xsl:template match="cat/text()"/>

</xsl:stylesheet>
