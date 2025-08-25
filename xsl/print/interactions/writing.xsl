<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="writing[@isInteraction='y']">
		<div class="{@printClass}" data-rcfid="{@id}">
            <xsl:choose>
                <xsl:when test="./presetAnswer">
                    <div class="rcfPrint-wol rcfPrint-presetAnswer">
                        <xsl:apply-templates select="./presetAnswer"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="rcfPrint-wol" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@printWritingLines and @printWritingLines > 1">
                    <xsl:call-template name="createWritingLines">
                        <xsl:with-param name="total" select="@printWritingLines"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="not(@printWritingLines) and ./ancestor::li">
                    <xsl:call-template name="createWritingLines">
                        <xsl:with-param name="total" select="2"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="not(@printWritingLines)">
                    <xsl:call-template name="createWritingLines">
                        <xsl:with-param name="total" select="5"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
		</div>
	</xsl:template>

    <xsl:template name="createWritingLines">
        <xsl:param name="index" select="1"/>
        <xsl:param name="total"/>
        <xsl:if test="not($index = $total) and not($index = 10)">
            <div class="rcfPrint-wol"></div>
            <xsl:call-template name="createWritingLines">
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="total" select="$total"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="writing[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
        <div class="{@printClass} rcfPrint-answer" data-rcfid="{@id}">

			<!-- answer model if included -->
			<xsl:apply-templates select="answerModel" mode="outputOpenGradableAnswerModel"/>

			<!-- marking guidance -->
			<xsl:call-template name="outputOpenGradableMarkingGuidance">
				<xsl:with-param name="markingGuidanceElement" select="markingGuidance"/>
				<xsl:with-param name="maxScore" select="@max_score"/>
			</xsl:call-template>

        </div>
    </xsl:template>

</xsl:stylesheet>
