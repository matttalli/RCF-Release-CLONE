<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings" exclude-result-prefixes="str"
                xmlns:exsl="http://xml.apache.org/xalan"
                version="1.0">

    <xsl:template match="textInput">
        <xsl:variable name="interactionType">
            <xsl:choose>
                <xsl:when test="@markedByTeacher='y'">openGradableTextInput</xsl:when>
                <xsl:otherwise>unmarkedTextInput</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="ariaLabel">
			<xsl:call-template name="typeinAriaLabel">
				<xsl:with-param name="typeinElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

        <xsl:variable name="interactionClass"><xsl:value-of select="$interactionType"/></xsl:variable>

		<input
			data-rcfinteraction="{$interactionType}"
			data-rcfid="{@id}"
			data-ignoreNextAnswer="y"
			type="text"
			class="{normalize-space(concat('text rcfTextInput ', @class))}"
			autocomplete="off"
			autocapitalize="off"
			spellcheck="false"
			autocorrect="off"
			data-rcfTranslate=""
			aria-label="{$ariaLabel}"
		>
            <xsl:if test="@max_score">
                <xsl:attribute name="data-maxscore"><xsl:value-of select="@max_score"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
        </input>
    </xsl:template>

    <xsl:template match="textInput[@markedByTeacher='y']" mode="getOpenGradableInteractionName">
        rcfOpenGradableTextInput
    </xsl:template>

    <xsl:template match="textInput[not(@markedByTeacher) or @markedByTeacher='n']" mode="getUnmarkedInteractionName">
        rcfTextInput
    </xsl:template>

    <!-- ignore prefix / acceptable / suffix / hint etc elements-->
    <xsl:template match="prefix"/>
    <xsl:template match="acceptable"/>
    <xsl:template match="suffix"/>
    <xsl:template match="hint"/>
    <!-- -->
</xsl:stylesheet>
