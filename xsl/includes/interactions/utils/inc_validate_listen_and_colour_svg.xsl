<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- validate the svg, if any errors detected, return the error messsages -->
	<xsl:template name="validateListenAndColourSvg">
		<xsl:param name="listenAndColour" />
		<xsl:variable name="svgFileName">
			<xsl:call-template name="getSvgLocation">
				<xsl:with-param name="env" select="$environment"/>
				<xsl:with-param name="svgHost" select="$host"/>
				<xsl:with-param name="svgPath" select="$svgFilePath"/>
				<xsl:with-param name="svgName" select="$listenAndColour/itemGroups/@svg"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="svgDoc" select="document($svgFileName)"/>
		<!-- validate itemGroups/items -->
		<xsl:variable name="itemGroupsItemsValid">
			<xsl:for-each select="$listenAndColour//item">
				<xsl:variable name="itemId" select="@name"/>
				<xsl:if test="count($svgDoc//*[@id=$itemId])=0"><h3>item with id <xsl:value-of select="$itemId"/> not found in svg</h3></xsl:if>
				<xsl:if test="contains(@name, &quot;'&quot;)"><h3>item with id [<xsl:value-of select="$itemId"/>] contains an apostrophe, this can break the interaction and is not recommended</h3></xsl:if>
				<xsl:if test="contains(@name, '&quot;')"><h3>item with id [<xsl:value-of select="$itemId"/>] contains at least one quote character, this can break the interaction and is not recommended</h3></xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:copy-of select="$itemGroupsItemsValid"/>
	</xsl:template>

</xsl:stylesheet>
