<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="radio[not(@example='y')] | itemRadio[not(@example='y')]" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			<xsl:if test="ancestor::story">
			"ignoreNextAnswer": "y",
			</xsl:if>
			<xsl:choose>
				<xsl:when test="count(item[@correct='y'])>1">
					"type": "choice",
					<xsl:choose>
						<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">
					"markType": "unmarked",
					"markedBy": "nobody",
						</xsl:when>
						<xsl:otherwise>
					"markType": "item",
					"markedBy": "engine",
						</xsl:otherwise>
					</xsl:choose>
					"value": [
					<xsl:for-each select="item[@correct='y']">
						"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					]
				</xsl:when>
				<xsl:otherwise>
					"type": "simple",
					<xsl:choose>
						<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">
					"markType": "unmarked",
					"markedBy": "nobody",
						</xsl:when>
						<xsl:when test="count(item[@correct='y'])=0">
					"markType": "unmarked",
					"markedBy": "nobody",
						</xsl:when>
						<xsl:when test="count(item[@correct='y'])>0">
					"markType": "item",
					"markedBy": "engine",
						</xsl:when>
					</xsl:choose>
					"value": "<xsl:value-of select="item[@correct='y']/@id"/>"
				</xsl:otherwise>
			</xsl:choose>
		}
	</xsl:template>

</xsl:stylesheet>
