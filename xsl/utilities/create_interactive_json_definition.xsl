<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" indent="yes"/>


	<xsl:template match="typein | mltypein">
	{
		id: "<xsl:value-of select="@id"/>",
		type: "<xsl:value-of select="local-name()"/>",
		class: "<xsl:value-of select="@class"/>",
		example: "<xsl:value-of select="@example"/>",
		prefix: "<xsl:value-of select="prefix"/>",
		suffix: "<xsl:value-of select="suffix"/>",
		answers: [
			<xsl:apply-templates select="acceptable/item"/>
		]
	}
	</xsl:template>

	<xsl:template match="acceptable/item">
		item: {
			id: "<xsl:value-of select="@id"/>",
			<xsl:if test="@class">
				class: "<xsl:value-of select="@class"/>",
			</xsl:if>
			<xsl:if test="@correct">
				correct: "<xsl:value-of select="@correct"/>",
			</xsl:if>
			value: "<xsl:value-of select="."/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="dropDown">
	{
		id: "<xsl:value-of select="@id"/>",
		type: "<xsl:value-of select="local-name()"/>",
		class: "<xsl:value-of select="@class"/>",
		example: "<xsl:value-of select="@example"/>",
		items: [
			<xsl:apply-templates select="item"/>
		]
	}
	</xsl:template>

	<xsl:template match="dropDown/item">
		{
			id: "<xsl:value-of select="@id"/>",
			correct: "<xsl:value-of select="@correct"/>",
			value: "<xsl:value-of select="."/>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="radio|checkbox">
	{
		id: "<xsl:value-of select="@id"/>",
		type: "<xsl:value-of select="local-name()"/>",
		class: "<xsl:value-of select="@class"/>",
		example: "<xsl:value-of select="@example"/>",
		display: "<xsl:value-of select="@display"/>", 
		displayType: "<xsl:value-of select="@displayType"/>",
		start: "<xsl:value-of select="@start"/>",
		reversed: "<xsl:value-of select="@reversed"/>",
		items: [
			<xsl:apply-templates select="item"/>
		]
	}
	</xsl:template>
	
	<xsl:template match="radio/item | checkbox/item">
		{
			id: "<xsl:value-of select="@id"/>,
			correct: "<xsl:value-of select="@correct"/>",
			caption: "<xsl:copy-of select="."/>",
			class: "<xsl:value-of select="@class"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="text()"/>

</xsl:stylesheet>