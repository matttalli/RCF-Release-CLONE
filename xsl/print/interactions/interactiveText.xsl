<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	selectable text template / transformation
-->
    <!-- Note:  in print we're only supporting interactiveText type="selectable" and type="selectableWords"
                we won't be supporting @type="selectableCat' and @type="selectableCatWords"  -->

    <xsl:template match="interactiveTextBlock[@isInteraction='y']">
        <xsl:variable name="typeClassName"> rcfPrint-type_<xsl:value-of select="@type"/></xsl:variable>
		<xsl:variable name="exampleClassName"><xsl:if test="@example='y'"> rcfPrint-example</xsl:if></xsl:variable>
		<div class="{normalize-space(concat(@printClass, $typeClassName, $exampleClassName))}" data-rcfid="{@id}">
			<!-- <xsl:call-template name="outputPrintNumber"/> -->
            <xsl:apply-templates/>
		</div>
	</xsl:template>

    <xsl:template match="interactiveTextBlock[@isInteraction='y']//eSpan">
		<xsl:variable name="className">rcfPrint-selectable
            <xsl:if test="@example='y'"> rcfPrint-example</xsl:if>
            <xsl:if test="ancestor::interactiveTextBlock[@example='y'] and @correct='y'"> rcfPrint-example rcfPrint-correct</xsl:if>
        </xsl:variable>

        <span class="{normalize-space($className)}" data-rcfid="{@id}">
            <xsl:apply-templates/>
        </span>
	</xsl:template>

    <xsl:template match="interactiveTextBlock[@isInteraction='y' and @type='selectableWords']//text()[not(ancestor::eSpan)]"  name="tokenizeSelectableWordsForPrint">
        <xsl:param name="text" select="."/>
        <xsl:param name="separator" select="' '"/>
		<xsl:param name="intID" select="'1'"/>
        <xsl:if test="not($text='')">
			<xsl:variable name="useID">
				<xsl:value-of select="ancestor::interactiveTextBlock/@id"/>_<xsl:value-of select="count(preceding::text())+1"/>_<xsl:value-of select="$intID"/>
			</xsl:variable>
            <xsl:variable name="outputText">
				<xsl:choose>
					<xsl:when test="not(contains($text, $separator))"><xsl:value-of select="normalize-space($text)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="normalize-space(substring-before($text, $separator))"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

            <xsl:if test="string-length($outputText) &gt; 0">
				<span class="{normalize-space('rcfPrint-selectable')}" data-rcfid="selectable_{$useID}">
					<xsl:value-of select="$outputText"/>
				</span><xsl:text> </xsl:text>
			</xsl:if>

			<xsl:if test="string-length($outputText) = 0">
                <xsl:text> </xsl:text>
			</xsl:if>

            <xsl:if test="contains($text, $separator) and $text!=$separator">
				<xsl:call-template name="tokenizeSelectableWordsForPrint">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="intID" select="$intID+1"/>
				</xsl:call-template>
			</xsl:if>
        </xsl:if>
    </xsl:template>

    <!--- answer key output -->
	<xsl:template match="interactiveTextBlock[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
        <xsl:variable name="typeClassName"> rcfPrint-type_<xsl:value-of select="@type"/></xsl:variable>
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> <xsl:value-of select="$typeClassName"/> rcfPrint-answer</xsl:variable>

        <xsl:if test="not(@example='y')">
            <span class="{$className}" data-rcfid="{@id}">
                <xsl:apply-templates mode="outputAnswerKey"/>
            </span>
        </xsl:if>

	</xsl:template>

    <xsl:template match="p[eSpan]" mode="outputAnswerKey">
        <p><xsl:apply-templates mode="outputAnswerKey"/></p>
    </xsl:template>

	<xsl:template match="interactiveTextBlock[@isInteraction='y']//eSpan" mode="outputAnswerKey">
		<xsl:variable name="className">rcfPrint-selectable
            <xsl:if test="@example='y'"> rcfPrint-example</xsl:if>
            <xsl:if test="@correct='y'"> rcfPrint-correct</xsl:if>
        </xsl:variable>

        <span class="{normalize-space($className)}" data-rcfid="{@id}">
            <xsl:apply-templates/>
        </span>
	</xsl:template>

    <xsl:template match="interactiveTextBlock[@isInteraction='y' and @type='selectableWords']//text()[not(ancestor::eSpan)]"  name="tokenizeSelectableWordsForPrintAnswerKey" mode="outputAnswerKey">
        <!-- Unfortunatly I am unable to find a way to reuse this template in a different 'mode' so I have had to do a sad copy & paste from above -->
        <xsl:param name="text" select="."/>
        <xsl:param name="separator" select="' '"/>
		<xsl:param name="intID" select="'1'"/>
        <xsl:if test="not($text='')">
			<xsl:variable name="useID">
				<xsl:value-of select="ancestor::interactiveTextBlock/@id"/>_<xsl:value-of select="count(preceding::text())+1"/>_<xsl:value-of select="$intID"/>
			</xsl:variable>
            <xsl:variable name="outputText">
				<xsl:choose>
					<xsl:when test="not(contains($text, $separator))"><xsl:value-of select="normalize-space($text)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="normalize-space(substring-before($text, $separator))"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

            <xsl:if test="string-length($outputText) &gt; 0">
				<span class="{normalize-space('rcfPrint-selectable')}" data-rcfid="selectable_{$useID}">
					<xsl:value-of select="$outputText"/>
				</span><xsl:text> </xsl:text>
			</xsl:if>

			<xsl:if test="string-length($outputText) = 0">
                <xsl:text> </xsl:text>
			</xsl:if>

            <xsl:if test="contains($text, $separator) and $text!=$separator">
				<xsl:call-template name="tokenizeSelectableWordsForPrintAnswerKey">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="intID" select="$intID+1"/>
				</xsl:call-template>
			</xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
