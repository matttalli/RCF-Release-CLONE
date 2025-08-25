<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="mathsAddition[not(@example='y')]" mode="outputAnswers">
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
			"type": "simple",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": "<xsl:value-of select="sum(number)"/>"
		}
	</xsl:template>

</xsl:stylesheet>
