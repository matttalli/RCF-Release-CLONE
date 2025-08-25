<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="mlTextInput | textInput" mode="outputAnswers">
		<xsl:variable name="requiredValue">
			<xsl:choose>
				<xsl:when test="@required"><xsl:value-of select="@required"/></xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="ancestor::activity/@gradable='open-gradable'">teacher</xsl:when>
				<xsl:when test="ancestor::activity/@gradable='open-non-gradable'">nobody</xsl:when>
				<xsl:when test="@markedByTeacher='y'">teacher</xsl:when>
				<xsl:otherwise>nobody</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "unmarked",
			"markType": "item",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"type": "simple",
			"required": "<xsl:value-of select="$requiredValue"/>",
			<xsl:call-template name="maxScore"/>
			"value": ""
		}
	</xsl:template>

</xsl:stylesheet>
