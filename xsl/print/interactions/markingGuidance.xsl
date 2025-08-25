<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template name="outputOpenGradableMarkingGuidance">
		<xsl:param name="markingGuidanceElement"/>
		<xsl:param name="maxScore"/>

		<div class="rcfPrint-markingGuidance">
			<!-- Marking guidance header -->
			<p><b data-rcfTranslate="">[ components.label.markingGuidance ]</b></p>

			<xsl:choose>
				<xsl:when test="string-length($markingGuidanceElement) > 0">
					<!-- When marking guidance text provided -->
					<p><xsl:apply-templates select="$markingGuidanceElement"/></p>
				</xsl:when>
				<xsl:when test="$maxScore > 1">
					<!-- When max score is more than 1  -->
					<p><span data-rcfTranslate="">[ components.label.assignUpTo ]</span><xsl:text> </xsl:text><xsl:value-of select="$maxScore" /><xsl:text> </xsl:text><span data-rcfTranslate="">[ components.label.points_other ]</span>.</p>
				</xsl:when>
				<xsl:otherwise>
					<!-- When max score is 1 -->
					<p data-rcfTranslate="">[ components.label.assignOnePoint ]</p>
				</xsl:otherwise>
			</xsl:choose>

		</div>
	</xsl:template>

</xsl:stylesheet>
