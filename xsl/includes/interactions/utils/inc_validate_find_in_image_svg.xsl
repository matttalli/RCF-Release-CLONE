<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- validate the svg, if any errors detected, return the error messsages -->
	<xsl:template name="validateFindInImageSvg">
		<xsl:param name="findInImage" />
		<xsl:variable name="svgFileName">
			<xsl:call-template name="getSvgLocation">
				<xsl:with-param name="env" select="$environment"/>
				<xsl:with-param name="svgHost" select="$host"/>
				<xsl:with-param name="svgPath" select="$svgFilePath"/>
				<xsl:with-param name="svgName" select="$findInImage/scene/@src"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="svgDoc" select="document($svgFileName)"/>

		<!-- validate items -->
		<xsl:variable name="itemsValid">
			<xsl:for-each select="$findInImage/items/item">
				<xsl:variable name="itemId" select="@id"/>
				<xsl:if test="count($svgDoc//*[@id=$itemId])=0"><h3>item with id [<xsl:value-of select="$itemId"/>] not found in svg</h3></xsl:if>
				<xsl:if test="contains(@id, &quot;'&quot;)"><h3>item with id [<xsl:value-of select="$itemId"/>] contains an apostrophe, this can break the interaction and is not recommended</h3></xsl:if>
				<xsl:if test="contains(@id, '&quot;')"><h3>item with id [<xsl:value-of select="$itemId"/>] contains at least one quote character, this can break the interaction and is not recommended</h3></xsl:if>
			</xsl:for-each>
			<xsl:if test="($findInImage/@play) and ($findInImage/@play) &gt; count($findInImage/questions/question)"><h3>PLAY value (<xsl:value-of select="$findInImage/@play"/>) is more than the number of questions available (<xsl:value-of select="count($findInImage/questions/question)"/>)</h3></xsl:if>
		</xsl:variable>
		<xsl:copy-of select="$itemsValid"/>
	</xsl:template>

</xsl:stylesheet>
