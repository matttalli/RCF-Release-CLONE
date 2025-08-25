<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="interactive">
		<xsl:variable name="classNames">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<section>
			<xsl:attribute name="class"><xsl:value-of select="normalize-space(concat('block mm_interactive interactive ', @class, ' ', $classNames))"/></xsl:attribute>
			<xsl:apply-templates/>
		</section>

	</xsl:template>

</xsl:stylesheet>
