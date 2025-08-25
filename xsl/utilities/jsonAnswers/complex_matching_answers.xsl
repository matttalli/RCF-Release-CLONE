<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="complexMatching[not(@example='y')]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>item</xsl:otherwise>
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
			"type": "composite",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": [
				<xsl:for-each select="matchTargets/matchTarget[not(@example='y')]">{
					<xsl:variable name="matchTargetId"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="jsonItemType">
						<xsl:choose>
							<xsl:when test="count(acceptable/item)>1">choice</xsl:when>
							<xsl:otherwise>simple</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
				"elm": "<xsl:value-of select="$matchTargetId"/>",
				"type": "<xsl:value-of select="$jsonItemType"/>",
				"markType": "item",
				"markedBy": "engine",
				<xsl:choose>
					<xsl:when test="$jsonItemType='choice'">
						"value": [
							<xsl:for-each select="acceptable/item">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
						]
					</xsl:when>
					<xsl:otherwise>
						"value": "<xsl:value-of select="acceptable/item/@id"/>"
					</xsl:otherwise>
				</xsl:choose>
				}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			]
		}
	</xsl:template>

	<xsl:template match="complexMatching/matchTargets/matchTarget[@example='y' and count(acceptable/item) &gt; 1]" mode="detectInvalidAnswers">
		, {
			"error": "complexMatching interaction <xsl:value-of select="ancestor::complexMatching/@id"/> has an example matchTarget element <xsl:value-of select="@id"/> with more than one acceptable answer"
		}
		<xsl:apply-templates mode="detectInvalidAnswers"/>
	</xsl:template>

	<xsl:template match="complexMatching/matchTargets/matchTarget[@example='y']/acceptable/item" mode="detectInvalidAnswers">
		<xsl:variable name="matchItemId" select="@id"/>
		<xsl:if test="ancestor::complexMatching/matchItems/matchItem[@id=$matchItemId]/@example != 'y'">
		, {
			"error": "complexMatching interaction <xsl:value-of select="ancestor::complexMatching/@id"/> has example matchTarget <xsl:value-of select="ancestor::matchTarget/@id"/> but corresponding match item <xsl:value-of select="$matchItemId"/> is NOT an example"
		}
		</xsl:if>
	</xsl:template>

	<xsl:template match="complexMatching/matchTargets/matchTarget[not(@example='y')]//item" mode="detectInvalidAnswers">
		<xsl:variable name="matchItemId" select="@id"/>
		<xsl:if test="count(ancestor::matchTargets/matchTarget[@example='y']//item[@id=$matchItemId]) > 0 or (ancestor::complexMatching/matchItems/matchItem[@id=$matchItemId]/@example='y')">
			, {
				"error": "complexMatching interaction <xsl:value-of select="ancestor::complexMatching/@id"/> has a matchTarget <xsl:value-of select="ancestor::matchTarget/@id"/> with a specified matchItem of <xsl:value-of select="$matchItemId"/> which is already used by an example / set as an example"
			}
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
