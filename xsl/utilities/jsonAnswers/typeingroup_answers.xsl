<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="typeinGroup[not(@example='y') and (count(.//typein[@example='y'])!=count(.//typein) )]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"type": "composite",
			"value": [
				<xsl:for-each select=".//typein[not(@example='y')]">
					<xsl:apply-templates select="." mode="outputAnswers"/><xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
	</xsl:template>

	<xsl:template match="typeinGroup[not(@example='y') and (count(.//typein)=0)]"  mode="detectInvalidAnswers">
		,{
			"error" : "Error ! no typein child elements in typein group '<xsl:value-of select="@id"/>'"
		}
	</xsl:template>

	<xsl:template match="itemTypeinGroup[not(@example='y') and (count(.//itemTypein[@example='y'])!=count(.//itemTypein))]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"type": "composite",
			"value": [
				<xsl:for-each select=".//itemTypein[not(@example='y')]">
					<xsl:apply-templates select="." mode="outputAnswers"/><xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
	</xsl:template>

	<xsl:template match="itemTypeinGroup[not(@example='y') and (count(.//itemTypein)=0)]"  mode="detectInvalidAnswers">
		,{
			"error" : "Error ! no itemTypein child elements in itemTypein group '<xsl:value-of select="@id"/>'"
		}
	</xsl:template>

</xsl:stylesheet>
