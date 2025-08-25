<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema"
version="1.0">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="xs:include">
		<xsl:variable name="filename" select="@schemaLocation"/>
		<xsl:comment>included from schema :<xsl:value-of select="$filename"/></xsl:comment>
		<xsl:apply-templates select="document($filename)" mode="external"/>
		<xsl:comment> .... <xsl:value-of select="$filename"/> (end)</xsl:comment>
	</xsl:template>

	<xsl:template match="xs:include/@*"/>
	<xsl:template match="xs:include/@*" mode="external"/>

	<xsl:template match="xs:schema" mode="external">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
</xsl:stylesheet>