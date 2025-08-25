<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="mathsDivision[not(@example='y')]" mode="outputAnswers">
		<!-- when markRemainder=y but using decimals, that's invalid, but we will just not use remainders -->
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="not(@markRemainder='y') or(@markRemainder='y' and @decimals &gt; 0)">item</xsl:when>
						<xsl:otherwise>list</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="answerType">
			<xsl:choose>
				<xsl:when test="not(@markRemainder='y') or (@markRemainder='y' and @decimals &gt; 0)">simple</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="numberOfDecimalPlaces">
			<xsl:choose>
				<xsl:when test="not(@decimals) or (@decimals='')">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="@decimals"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="showWorking">
			<xsl:choose>
				<xsl:when test="not(@showWorking) or (@showWorking='')">n</xsl:when>
				<xsl:when test="@showWorking='y'">y</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- build the output format string based on the number of decimal places variable -->
		<xsl:variable name="integerPlaces">##########</xsl:variable>
		<xsl:variable name="decimalPlacesFormat"><xsl:value-of select="substring('####################', 1, $numberOfDecimalPlaces)"/></xsl:variable>

		<xsl:variable name="numberFormat">
			<xsl:choose>
				<xsl:when test="$numberOfDecimalPlaces=0"><xsl:value-of select="$integerPlaces"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="concat($integerPlaces, '.', $decimalPlacesFormat)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="rawAnswer" select="number[1] div number[2]"/>

		<xsl:variable name="expectedAnswer">
			<xsl:choose>
				<xsl:when test="@rounding='y'">
					<xsl:value-of select="normalize-space(format-number((number[1] div number[2]), $numberFormat))"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- need to truncate the answer to '$numberOfDecimalPlaces' decimal places -->
					<xsl:choose>
						<xsl:when test="contains($rawAnswer, '.') and $numberOfDecimalPlaces &gt; 0">
							<xsl:value-of select="substring-before($rawAnswer, '.')"/>
							<xsl:text>.</xsl:text>
							<xsl:value-of select="substring($rawAnswer, string-length(substring-before($rawAnswer, '.')) + 2, $numberOfDecimalPlaces)"/>
						</xsl:when>
						<xsl:when test="contains($rawAnswer, '.') and $numberOfDecimalPlaces = 0">
							<xsl:value-of select="substring-before($rawAnswer, '.')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(format-number($rawAnswer, $numberFormat))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="remainder"><xsl:value-of select="normalize-space(format-number(number[1] mod number[2], $numberFormat))"/></xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "<xsl:value-of select="$answerType"/>",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",

			<xsl:if test="$showWorking='y'">
				"workingValues": "internal",
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$answerType='list'">
					"value": [
						"<xsl:value-of select="$expectedAnswer"/>",
						"<xsl:value-of select="$remainder"/>"
					]
				</xsl:when>
				<xsl:otherwise>
					"value": "<xsl:value-of select="$expectedAnswer"/>"
				</xsl:otherwise>
			</xsl:choose>
		}
	</xsl:template>

</xsl:stylesheet>
