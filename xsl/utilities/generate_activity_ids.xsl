<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	generate_activity_ids.xsl

	Chris Eastwood, August 2012 for Macmillan Education

	This stylesheet will take an xml file and generate ID's for all the activities in the XML, based upon their position
	- so the first Activity has id 'act1', the second 'act2' etc etc
	- all other attributes are copied over
	- any existing ID on the activity is replaced with the new one !!
-->
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>


	<!-- if we match activity, generate a new ID for it -->
	<xsl:template match="activity">
		<xsl:variable name="actNum">act<xsl:value-of select="count(preceding::activity)+1"/></xsl:variable>
		<xsl:variable name="newID">
			<xsl:choose>
				<xsl:when test="not(@id)"><xsl:value-of select="$actNum"/><xsl:if test="count(//activity[@id=$actNum])>0">b</xsl:if></xsl:when>
				<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="activity">
			<xsl:attribute name="id"><xsl:value-of select="$newID"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- if we match an existing ID in activity, just ignore it -->
	<xsl:template match="activity/@id"/>

	<!-- if we match an infoBlock, generate a new id for it -->
	<xsl:template match="infoBlock">
		<xsl:variable name="infoBlockNum">ib<xsl:value-of select="count(preceding::infoBlock)+1"/><xsl:if test="count(ancestor::infoBlock)>0">_<xsl:value-of select="count(ancestor::infoBlock)"/></xsl:if></xsl:variable>
		<xsl:variable name="newID">
			<xsl:choose>
				<xsl:when test="not(@id)"><xsl:value-of select="$infoBlockNum"/><xsl:if test="count(//infoBlock[@id=$infoBlockNum])>0">b</xsl:if></xsl:when>
				<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="infoBlock">
			<xsl:attribute name="id"><xsl:value-of select="$newID"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="infoBlock/@id" />

	<!-- deep copy any other attributes / elements -->
	<xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
	<!-- -->

</xsl:stylesheet>
