<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="mathsMultiplication[not(@example='y')]" mode="outputAnswers">
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
			<xsl:value-of select="string-length(substring-after(number[1], '.')) + string-length(substring-after(number[2], '.'))"/>
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

		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "simple",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": "<xsl:value-of select="normalize-space(format-number((number[1] * number[2]), $numberFormat))"/>",
			"workingValues": [
				<xsl:apply-templates select="." mode="outputWorkingValues"/>
			]
		}
	</xsl:template>


	<xsl:template match="mathsMultiplication" mode="outputWorkingValues">
		<xsl:variable name="sortedNumbers">
			<xsl:for-each select="./number">
				<xsl:sort select="text()" data-type="number" order="descending"/>
				<xsl:value-of select="."/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="biggest">
			<xsl:choose>
				<xsl:when test="number[1]/text() &gt; number[2]/text()">
					<xsl:value-of select="number[1]/text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number[2]/text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="smallest">
			<xsl:choose>
				<xsl:when test="number[1]/text() &lt; number[2]/text()">
					<xsl:value-of select="number[1]/text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number[2]/text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="multiplicand" select="translate($biggest, '.-', '')"/>
		<xsl:variable name="multiplier" select="translate($smallest, '.-', '')"/>

		<xsl:variable name="reverseMultiplier">
			<xsl:call-template name="reverseValue">
				<xsl:with-param name="input" select="$multiplier"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="sumMultiplicandByMultiplier">
			<xsl:with-param name="multiplicand" select="$multiplicand"/>
			<xsl:with-param name="multiplier" select="$reverseMultiplier"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template name="reverseValue">
		<xsl:param name="input"/>

		<xsl:variable name="len" select="string-length($input)"/>
		<xsl:choose>
			<xsl:when test="$len &lt; 2">
				<xsl:value-of select="$input"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="mid" select="floor($len div 2)"/>
				<xsl:call-template name="reverseValue">
						<xsl:with-param name="input"
							select="substring($input,$mid+1,$mid+1)"/>
				</xsl:call-template>
				<xsl:call-template name="reverseValue">
						<xsl:with-param name="input"
							select="substring($input,1,$mid)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sumMultiplicandByMultiplier">
		<xsl:param name="multiplicand"/>
		<xsl:param name="multiplier"/>

		<xsl:if test="string-length($multiplier) > 0">
			<xsl:variable name="multiplierValue" select="substring($multiplier, 1, 1)"/>
			<xsl:variable name="sumValue" select="$multiplicand * $multiplierValue"/>
			"<xsl:value-of select="$sumValue"/>"<xsl:if test="string-length($multiplier)>1">,</xsl:if>
			<xsl:call-template name="sumMultiplicandByMultiplier">
				<xsl:with-param name="multiplier" select="substring($multiplier, 2)"/>
				<xsl:with-param name="multiplicand" select="$multiplicand"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
