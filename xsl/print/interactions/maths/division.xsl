<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- use the new division utils xsl templates for calculating html properties to be passed to the js -->
	<xsl:include href="../../../includes/interactions/math/division/inc_rcf_division_utils.xsl"/>

	<xsl:template match="mathsDivision[@isInteraction='y']">

		<xsl:variable name="outputDecimalNotation">
			<xsl:call-template name="getOutputDecimalNotation">
				<xsl:with-param name="decimalNotation" select="@decimalNotation"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="markRemainder">
			<xsl:call-template name="getMarkRemainder">
				<xsl:with-param name="markRemainder" select="@markRemainder"/>
				<xsl:with-param name="decimals" select="@decimals"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="showWorking">
			<xsl:call-template name="getShowWorking">
				<xsl:with-param name="markRemainder" select="$markRemainder"/>
				<xsl:with-param name="showWorking" select="@showWorking"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="layout">
			<xsl:call-template name="getLayout">
				<xsl:with-param name="layout" select="@layout"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="rounding">
			<xsl:call-template name="getRounding">
				<xsl:with-param name="rounding" select="@rounding"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="decimalPlaces">
			<xsl:call-template name="getDecimalPlaces">
				<xsl:with-param name="decimals" select="@decimals"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="exampleClass">
			<xsl:call-template name="getExampleClass">
				<xsl:with-param name="example" select="@example"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="layoutClass">
			<xsl:call-template name="getLayoutClass">
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="overrideClasses">
			<xsl:call-template name="getOverrideClasses">
				<xsl:with-param name="markRemainder" select="$markRemainder"/>
				<xsl:with-param name="showWorkingAttribute" select="@showWorking"/>
			</xsl:call-template>
		</xsl:variable>


		<div data-rcfInteraction="mathsDivision"
			data-rcfId="{@id}"
			class="{normalize-space(concat(@printClass, ' mathsInteraction division ', $layoutClass, ' ', $overrideClasses, ' ', $exampleClass))}"
			data-rcfDecimalNotation="{$outputDecimalNotation}"
			data-rcfShowWorking="{$showWorking}"
			data-rcfMarkRemainder="{$markRemainder}"
			data-rcfLayout="{$layout}"
			data-rcfRounding="{$rounding}"
			data-rcfDecimalPlaces="{$decimalPlaces}"
			data-rcfNumbers="{number[1]}|{number[2]}"
		>
			<xsl:comment>Division interaction populated here</xsl:comment>
		</div>
	</xsl:template>


	<xsl:template match="mathsDivision[@isInteraction='y' and not(@example='y')]" mode="outputAnswerKeyValueForInteraction">

		<xsl:variable name="outputDecimalNotation">
			<xsl:call-template name="getOutputDecimalNotation">
				<xsl:with-param name="decimalNotation" select="@decimalNotation"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="markRemainder">
			<xsl:call-template name="getMarkRemainder">
				<xsl:with-param name="markRemainder" select="@markRemainder"/>
				<xsl:with-param name="decimals" select="@decimals"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="showWorking">
			<xsl:call-template name="getShowWorking">
				<xsl:with-param name="markRemainder" select="$markRemainder"/>
				<xsl:with-param name="showWorking" select="@showWorking"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="layout">
			<xsl:call-template name="getLayout">
				<xsl:with-param name="layout" select="@layout"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="rounding">
			<xsl:call-template name="getRounding">
				<xsl:with-param name="rounding" select="@rounding"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="decimalPlaces">
			<xsl:call-template name="getDecimalPlaces">
				<xsl:with-param name="decimals" select="@decimals"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- always want the answerKey division to be output as an example so that all working / answers are shown -->
		<xsl:variable name="exampleClass">example</xsl:variable>

		<xsl:variable name="layoutClass">
			<xsl:call-template name="getLayoutClass">
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="overrideClasses">
			<xsl:call-template name="getOverrideClasses">
				<xsl:with-param name="markRemainder" select="$markRemainder"/>
				<xsl:with-param name="showWorkingAttribute" select="@showWorking"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- build the output format string based on the number of decimal places variable -->
		<xsl:variable name="integerPlaces">##########</xsl:variable>
		<xsl:variable name="decimalPlacesFormat"><xsl:value-of select="substring('####################', 1, $decimalPlaces)"/></xsl:variable>

		<xsl:variable name="numberFormat">
			<xsl:choose>
				<xsl:when test="$decimalPlaces=0"><xsl:value-of select="$integerPlaces"/></xsl:when>
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
					<!-- need to truncate the answer to '$decimalPlaces' decimal places -->
					<xsl:choose>
						<xsl:when test="contains($rawAnswer, '.') and $decimalPlaces &gt; 0">
							<xsl:value-of select="substring-before($rawAnswer, '.')"/>
							<xsl:text>.</xsl:text>
							<xsl:value-of select="substring($rawAnswer, string-length(substring-before($rawAnswer, '.')) + 2, $decimalPlaces)"/>
						</xsl:when>
						<xsl:when test="contains($rawAnswer, '.') and $decimalPlaces = 0">
							<xsl:value-of select="substring-before($rawAnswer, '.')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(format-number($rawAnswer, $numberFormat))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="calculatedRemainder"><xsl:value-of select="normalize-space(format-number(number[1] mod number[2], $numberFormat))"/></xsl:variable>


		<xsl:for-each select="number">
			<xsl:variable name="currentValue">
				<xsl:value-of select="translate(., '.', $outputDecimalNotation)"/>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test=". &lt; 1 and . &gt; 0 and not(substring($currentValue,1 ,1)='0')">0<xsl:value-of select="$currentValue"/></xsl:when>
				<xsl:when test=". &lt; 0">(<xsl:value-of select="$currentValue"/>)</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentValue"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position() != last()"><xsl:text disable-output-escaping="yes"> <![CDATA[&]]>divide; </xsl:text></xsl:if>
		</xsl:for-each> = <b><xsl:value-of select="$expectedAnswer"/></b><xsl:if test="@markRemainder='y' and (not(@decimals) or (@decimals='') or (@decimals='0'))"> R <b><xsl:value-of select="$calculatedRemainder"/></b></xsl:if>

		<div data-rcfInteraction="mathsDivision"
			data-rcfId="{@id}-answerKey"
			class="{normalize-space(concat(@class, ' mathsInteraction division ', $layoutClass, ' ', $overrideClasses, ' ', $exampleClass))}"
			data-rcfDecimalNotation="{$outputDecimalNotation}"
			data-rcfShowWorking="{$showWorking}"
			data-rcfMarkRemainder="{$markRemainder}"
			data-rcfLayout="{$layout}"
			data-rcfRounding="{$rounding}"
			data-rcfDecimalPlaces="{$decimalPlaces}"
			data-rcfNumbers="{number[1]}|{number[2]}"
		>
			<xsl:comment>Division interaction populated here</xsl:comment>
		</div>
	</xsl:template>

	<xsl:template match="mathsDivision/number" mode="outputAnswerKeyValueForInteraction"/>

</xsl:stylesheet>
