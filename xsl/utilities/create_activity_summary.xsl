<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8" standalone="yes" indent="no"/>

	<xsl:param name="activitySetString" select="'missing activity set string'"/>
	<xsl:param name="activitySetID" select="'missing activity set ID'"/>
	<xsl:param name="activityScreenString" select="'missing activity screen string'"/>

	<xsl:template match="activity">
		<activity id="{@id}">
			<xsl:apply-templates/>
		</activity>
	</xsl:template>

	<xsl:template match="categorise">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="complexCategorise">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="ordering[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="positioning[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="complexOrdering[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="droppable[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="complexDroppable[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="typein[not(@example='y') and not(ancestor::locating/@example='y') and not(ancestor::typeinGroup)]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="locating[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="typeinGroup[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="mlTypein[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="dropDown[not(@example='y') and not(ancestor::locating)]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="checkbox[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="interactiveTextBlock[@type='selectableCat' or @type='selectableCatWords']">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="checkbox[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="wordSnake[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template match="wordSearchGrid[not(@example='y')]">
		<xsl:call-template name="outputItem"/>
	</xsl:template>
	<xsl:template name="outputItem">"<xsl:value-of select="$activitySetString"/>","<xsl:value-of select="$activitySetID"/>","<xsl:value-of select="$activityScreenString"/>","<xsl:value-of select="ancestor::activity/@id"/>","<xsl:apply-templates select="//rubric" mode="rubric"/>","<xsl:value-of select="$activityScreenString"/>-<xsl:value-of select="@id"/>", "<xsl:value-of select="name()"/>"
</xsl:template>
	<xsl:template match="rubric" mode="rubric"><xsl:value-of select="normalize-space(.)"/></xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>