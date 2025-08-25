<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="recording[@isInteraction='y']">
		<div class="{@printClass}" data-rcfid="{@id}"></div>
	</xsl:template>

    <xsl:template match="recording[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
        <xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer</xsl:variable>
        <div class="{normalize-space($className)}" data-rcfid="{@id}">

			<!-- marking guidance -->
			<xsl:call-template name="outputOpenGradableMarkingGuidance">
				<xsl:with-param name="markingGuidanceElement" select="markingGuidance"/>
				<xsl:with-param name="maxScore" select="@max_score"/>
			</xsl:call-template>

        </div>
	</xsl:template>

</xsl:stylesheet>
