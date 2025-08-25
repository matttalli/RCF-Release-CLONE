<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" />

	<xsl:template match="/">
		<xsl:text># RCF Activity Transformation Parameters</xsl:text><xsl:text>&#13;</xsl:text>
		<xsl:text>These are the parameters passed to the `create_rcf_activity.xsl` transformation which creates the RCF activity html fragment.</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>This document is generated programatically using : &#13;&#13;</xsl:text>
		<xsl:text>&#x9;xsltproc xsl/generate-transform-parameters-doc.xsl xsl/includes/parameters/inc_transformation_parameters.xsl&#13;&#13;&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>... and then piping the output where required.</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="//xsl:param"/>
	</xsl:template>

	<xsl:template match="xsl:param">
		<xsl:text>#&#13;</xsl:text>
		<xsl:text>## </xsl:text><xsl:value-of select="@name"/><xsl:text>   </xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes">&gt;</xsl:text>####<xsl:value-of select="preceding-sibling::comment()[1]"/>
		<xsl:text>&#13;</xsl:text>

		<xsl:text>&gt;</xsl:text>```&lt;xsl:param name="<xsl:value-of select="@name"/>"<xsl:if test="@select"><xsl:text> </xsl:text>select="<xsl:value-of select="@select"/></xsl:if>&gt;```
		<xsl:text>&#13;</xsl:text>

	</xsl:template>

</xsl:stylesheet>
