<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   version="1.0">
<!-- <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>
 -->
<xsl:output method="text" encoding="UTF-8" indent="yes"/>
<xsl:include href="../includes/inc_utils.xsl"/>


<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="product">
	<xsl:variable name="layout">
		<xsl:choose>
			<xsl:when test="metadata/spkLayout"><xsl:value-of select="metadata/spkLayout"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="theme">
		<xsl:choose>
			<xsl:when test="metadata/spkTheme"><xsl:value-of select="metadata/spkTheme"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="dictionary">
		<xsl:choose>
			<xsl:when test="metadata/dictionary"><xsl:value-of select="metadata/dictionary"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
{
	"title": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/title"/></xsl:call-template>",
	"series": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/series"/></xsl:call-template>",
	"level": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/level"/></xsl:call-template>",
	"levelCss": {
		"core": "<xsl:value-of select="metadata/css/@url"/>",
		"768": "<xsl:value-of select="metadata/css_768/@url"/>",
		"1024": "<xsl:value-of select="metadata/css_1024/@url"/>"
	},
	"cover_image": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/coverImage/@url"/></xsl:call-template>",
	"logo": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/courseImage/@url"/></xsl:call-template>",
	"color_bar": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/colors/color1"/></xsl:call-template>",
	"background_color": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/colors/color2"/></xsl:call-template>",
	"background_image": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/dashboardImage/@url"/></xsl:call-template>",
	"activities_image": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/navflyoutImage/@url"/></xsl:call-template>",
	"acknowledgement": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="referenceContentItems/referenceContentItem[@type='acknowledgement']/@url"/></xsl:call-template>",
	"layout": "<xsl:value-of select="$layout"/>",
	"theme": "<xsl:value-of select="$theme"/>",
	"dictionary": "<xsl:value-of select="$dictionary"/>",
	"units": [
		<xsl:apply-templates select="branch[@type='unit']"/>
	]
}
</xsl:template>

<!--
	"<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select=""/></xsl:call-template>",
-->
<xsl:template match="branch[@type='unit']">
		{
			"unitId": <xsl:value-of select="count(preceding-sibling::branch[@type='unit'])"/>,
			"title": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/title"/></xsl:call-template>",
			"subtitle": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/subtitle"/></xsl:call-template>",
			"label": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/label"/></xsl:call-template>",
			"color": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/unitColor"/></xsl:call-template>",
			"text_color": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/unitTextColor"/></xsl:call-template>",
			"thumb": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/thumb/@url"/></xsl:call-template>",
			<xsl:if test="count(branch[@type='songs'])>0">
			"songs": [
				<xsl:apply-templates select="branch[@type='songs']"/>
			],
			</xsl:if>
			<xsl:if test="count(branch[@type='videos'])>0">
			"videos": [
				<xsl:apply-templates select="branch[@type='videos']"/>
			],
			</xsl:if>
			"activity_sets": [
				<xsl:apply-templates select="activitySets/activitySet"/>
			]
		}<xsl:if test="count(following-sibling::branch[@type='unit'])>0">,</xsl:if>
</xsl:template>

<xsl:template match="activitySet">
				{
					"title": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/title"/></xsl:call-template>",
					"thumb": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/thumb/@url"/></xsl:call-template>",
					"activities": [
						<xsl:apply-templates select="activities/activity"/>
					]
				}<xsl:if test="count(following-sibling::activitySet)>0">,</xsl:if>
</xsl:template>

<xsl:template match="branch[@type='songs' or @type='videos']">
	<xsl:for-each select="activitySets/activitySet">
				{
					"title": "<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="metadata/title"/></xsl:call-template>",
					"id": "<xsl:value-of select="activities/activity[1]/@id"/>",
					"type": "<xsl:value-of select="activities/activity[1]/@type"/>"
				}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>

</xsl:template>

<xsl:template match="activity">
						{
							"activityId": <xsl:value-of select="count(preceding-sibling::activity)"/>,
							"id": "<xsl:value-of select="@id"/>",
							"type": "<xsl:value-of select="@type"/>"
						}<xsl:if test="count(following-sibling::activity)>0">,</xsl:if>
					</xsl:template>
<xsl:template match="text()"/>

</xsl:stylesheet>
