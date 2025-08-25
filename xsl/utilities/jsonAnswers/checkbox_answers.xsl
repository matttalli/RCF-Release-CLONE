<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="checkbox[(not(@example='y')) and not(count(item[@example='y']) = count(item))]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="count(item[@correct='y'])=0 or @marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@mark='' or not(@mark)">item</xsl:when>
						<xsl:otherwise><xsl:value-of select="@mark"/></xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
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
			<xsl:if test="$penaliseWrongAnswers='y' and $markType='item'">
			"penaliseWrongAnswers": "y",
			</xsl:if>
			"type": "list",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": [
				<xsl:for-each select="item[@correct='y' and not(@example='y')]">
					"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
	</xsl:template>


</xsl:stylesheet>
