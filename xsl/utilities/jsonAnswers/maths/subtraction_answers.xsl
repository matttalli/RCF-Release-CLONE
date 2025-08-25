<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="mathsSubtraction[not(@example='y')]" mode="outputAnswers">
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

		<xsl:variable name="numberOfDecimalPlaces">
			<xsl:for-each select="number">
				<xsl:sort data-type="number" order="descending"/>
				<xsl:if test="not(floor(.) = .)">
					<xsl:value-of select="string-length(substring-after(., '.'))"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="outputFormat">##########.##########</xsl:variable>

		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "simple",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": "<xsl:value-of select="format-number(((number[1] * 2) - sum(./number) ), $outputFormat)"/>"
		}
	</xsl:template>

</xsl:stylesheet>
