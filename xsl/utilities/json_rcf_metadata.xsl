<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes"/>

	<xsl:template match="metadata">
		<!-- escape the title, subtitle, description and label metadata to ensure quotes and LF can be used -->
		<xsl:variable name="validTitle">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="title"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validSubtitle">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="subtitle"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validLabel">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="label"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validDescription">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="description"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validPrintPageReference">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="printPageReference"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validPrintActivityNumber">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="printActivityNumber"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validComponent">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="component"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validLevel">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="level"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="validIsland">
			<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="island"/></xsl:call-template></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>


		{
		<xsl:if test="id">
			"id": "<xsl:value-of select="id"/>",
		</xsl:if>

		"title": "<xsl:value-of select="$validTitle"/>",
		<xsl:if test="title/@lang">
		"titleLang": "<xsl:value-of select="title/@lang"/>",
		</xsl:if>

		"subtitle": "<xsl:value-of select="$validSubtitle"/>",
		<xsl:if test="subtitle/@lang">
			"subtitleLang": "<xsl:value-of select="subtitle/@lang"/>",
		</xsl:if>

		"label": "<xsl:value-of select="$validLabel"/>",
		"description": "<xsl:value-of select="$validDescription"/>",
		<xsl:if test="description/@lang">
			"descriptionLang": "<xsl:value-of select="description/@lang"/>",
		</xsl:if>

		"component": "<xsl:value-of select="$validComponent"/>",
		"level": "<xsl:value-of select="$validLevel"/>",
		<xsl:if test="count(referenceContentItems/referenceContentItem)>0">
			"referenceItems": [
			<xsl:for-each select="referenceContentItems/referenceContentItem">{
				"id": "<xsl:value-of select="@id"/>"
				}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
			],
		</xsl:if>
		<xsl:if test="publish">
			"publish": "<xsl:value-of select="publish"/>",
		</xsl:if>
		<xsl:if test="isNewsItem">
			"isNewsItem": "<xsl:value-of select="isNewsItem"/>",
		</xsl:if>
		<xsl:if test="inTLP">
			"inTLP": "<xsl:value-of select="inTLP"/>",
		</xsl:if>
		<xsl:if test="isAlternativeSourceType">
			"isAlternativeSourceType": "<xsl:value-of select="isAlternativeSourceType"/>",
		</xsl:if>
		<xsl:if test="noInheritance">
			"noInheritance": "<xsl:value-of select="noInheritance"/>",
		</xsl:if>
		<xsl:if test="sourceType">
			"sourceType": "<xsl:value-of select="sourceType"/>",
		</xsl:if>
		<xsl:if test="accessRights/contentId">
			"contentId": "<xsl:value-of select="accessRights/contentId"/>",
		</xsl:if>
		<xsl:if test="levelTaxonomyRoot">
			"levelTaxonomyRoot": "<xsl:value-of select="levelTaxonomyRoot"/>",
		</xsl:if>
		<xsl:if test="alternativeSourceType">
			"alternativeSourceType": "<xsl:value-of select="alternativeSourceType"/>",
		</xsl:if>
		<xsl:if test="activityRepresentationType">
			"activityRepresentationType": "<xsl:value-of select="activityRepresentationType"/>",
		</xsl:if>

		<!-- colour hack for devbliss -->
		"colors": {
		<xsl:for-each select="colors/*">"<xsl:value-of select="name()"/>": "<xsl:value-of select="."/>"
			<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>
		},
		"thumb": "<xsl:value-of select="thumb/@url"/>",
		"courseImage": "<xsl:value-of select="courseImage/@url"/>",
		"dashboardImage": "<xsl:value-of select="dashboardImage/@url"/>",
		"backgroundImage": "<xsl:value-of select="backgroundImage/@url"/>",
		"navflyoutImage": "<xsl:value-of select="navflyoutImage/@url"/>",
		<xsl:choose>
			<xsl:when test="showOrientationDeviceNotification">
				"showOrientationDeviceNotification": "<xsl:value-of select="showOrientationDeviceNotification"/>",
			</xsl:when>
			<xsl:otherwise>
				"showOrientationDeviceNotification": "n",
			</xsl:otherwise>
		</xsl:choose>
		<!-- spk properties -->
		"coverImage": "<xsl:value-of select="coverImage/@url"/>",
		"spkLayout": "<xsl:value-of select="spkLayout"/>",
		"spkTheme": "<xsl:value-of select="spkTheme"/>",
		"dictionary": "<xsl:value-of select="dictionary"/>",
		"unitColor": "<xsl:value-of select="unitColor"/>",
		"unitTextColor": "<xsl:value-of select="unitTextColor"/>",
		"color": "<xsl:value-of select="color"/>",
		"textColor": "<xsl:value-of select="textColor"/>",
		<xsl:if test="activityCategories">
			"activityCategories": [<xsl:for-each select="activityCategories/*">{
			"name":"<xsl:value-of select="." />",
			"icon":"<xsl:value-of select="./@icon"/>",
			"background": "<xsl:value-of select="./@background" />"
			}
			<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
			],
		</xsl:if>
		"colorGradient": "<xsl:value-of select="colorGradient"/>",
		"credits": "<xsl:value-of select="credits"/>",
		"termsAndConditions": "<xsl:value-of select="termsAndConditions"/>",
		"activitiesImage": "<xsl:value-of select="activitiesImage/@url"/>",
		"logoImage": "<xsl:value-of select="logoImage/@url"/>",
		"scoreImage": "<xsl:value-of select="scoreImage/@url"/>",
		"mainCategory": "<xsl:value-of select="mainCategory"/>",
		"scoreBackground": "<xsl:value-of select="scoreBackground/@url"/>",
		"backgroundColor": "<xsl:value-of select="backgroundColor" />",
		<!-- PBF-y bits -->
		"printPageReference": "<xsl:value-of select="$validPrintPageReference"/>",
		"printActivityNumber": "<xsl:value-of select="$validPrintActivityNumber"/>",
		"island": "<xsl:value-of select="$validIsland"/>",
		"expiryDate": "<xsl:value-of select="expiryDate"/>",
		<!-- this will need to be changed when we allow multiple values -->
		"alternativeSourceTypes": "<xsl:value-of select="alternativeSourceTypes/item"/>",
		"navioTheme": "<xsl:value-of select="navioTheme"/>",

		<!-- player decoration properties -->
		<xsl:if test="playerDecoration">
			<xsl:if test="playerDecoration/headerBackground">
				"headerBackgroundColor": "<xsl:value-of select="playerDecoration/headerBackground/@color"/>",
			</xsl:if>

			<xsl:if test="playerDecoration/headerText">
				"headerTextColor": "<xsl:value-of select="playerDecoration/headerText/@color"/>",
			</xsl:if>

			<xsl:if test="playerDecoration/navigationSeparator">
				"navigationSeparatorColor": "<xsl:value-of select="playerDecoration/navigationSeparator/@color"/>",
			</xsl:if>

			<xsl:if test="playerDecoration/headerImage">
				"headerImage": {
					<xsl:if test="playerDecoration/headerImage/@type">
					"type": "<xsl:value-of select="playerDecoration/headerImage/@type"/>",
					</xsl:if>
					<xsl:if test="playerDecoration/headerImage/@sharedAsset">
					"path": "<xsl:value-of select="playerDecoration/headerImage/@sharedAsset"/>"
					</xsl:if>
				},
			</xsl:if>
		</xsl:if>

		<!-- output list style metadata -->
		<xsl:apply-templates />

		<!-- instant feedback properties -->

		<xsl:choose>
			<xsl:when test="instantFeedbackDelay">
				"instantFeedbackDelay": "<xsl:value-of select="instantFeedbackDelay"/>"
			</xsl:when>
			<xsl:otherwise>
				"instantFeedbackDelay": "1500"
			</xsl:otherwise>
		</xsl:choose>

	}
	</xsl:template>

	<!-- generic template match for repetititve metadata value pairs/array output-->
	<xsl:template match="educationalAlignment | keyCourseAim | skill | learningObjective | grammarPronPoint | lexicalSet | coreVocabularyItems | recycledVocabularyItems | vocabularyItems | printPagesReference" >
		"<xsl:value-of select="name()"/>": [
			<xsl:for-each select="*">{
				"desc": "<xsl:call-template name="escapeQuote">
				<xsl:with-param name="textValue"><xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="."/></xsl:call-template></xsl:with-param>
			</xsl:call-template>"
			}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		],

	</xsl:template>

	<!-- ignore / don't output any text nodes by default -->
	<xsl:template match="text()"/>

	<xsl:template name="escapeText" >
		<xsl:param name="textValue" select="."/>
		<xsl:choose>
			<xsl:when test="not(contains($textValue, '&#10;'))">
				<xsl:value-of select="$textValue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="substring-before($textValue, '&#10;')"/>\n<xsl:call-template name="escapeText"><xsl:with-param name="textValue" select="substring-after($textValue, '&#10;')"/></xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="escapeQuote">
		<xsl:param name="textValue" select="."/>

		<xsl:if test="string-length($textValue) >0">
			<xsl:value-of select="substring-before(concat($textValue, '&quot;'), '&quot;')"/>

			<xsl:if test="contains($textValue, '&quot;')">
				<xsl:text>\"</xsl:text>
				<xsl:call-template name="escapeQuote">
					<xsl:with-param name="textValue" select="substring-after($textValue, '&quot;')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
