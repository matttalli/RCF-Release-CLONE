<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="interactiveTextBlock[not(@example='y') and (@mark='item' or @mark='' or not(@mark)) and not(@type='selectableCat' or @type='selectableCatWords')]" mode="pointsCalculation">
		<value><xsl:value-of select="count(.//eSpan[@correct='y' and not(@example='y') and not(@marked='n') and not(@distractor='y')])"/></value>
		<xsl:apply-templates mode="pointsCalculation"/>
	</xsl:template>

	<xsl:template match="interactiveTextBlock[@mark='list' and (@type='selectable' or @type='selectableWords') and not(@marked='n') and not(@example='y') and count(.//eSpan[@correct='y' and not(@example='y')	and not(@marked='n') and not(@distractor='y')]) &gt; 0]" mode="pointsCalculation">
		<value>1</value>
		<xsl:apply-templates mode="pointsCalculation"/>
	</xsl:template>

	<xsl:template match="interactiveTextBlock[not(@example='y') and not(@marked='n') and (@type='selectableCat' or @type='selectableCatWords')]" mode="pointsCalculation">
		<value><xsl:value-of select="count(.//eSpan[not(@example='y') and not(@distractor='y') and not(@marked='n') and (@cat != '')])"/></value>
	</xsl:template>

	<xsl:template match="eDiv[@correct='y' and not(@example='y') and not(@marked='n')]" mode="pointsCalculation">
		<value>1</value>
	</xsl:template>

	<xsl:template match="interactiveTextBlock[not(@example='y') and (@type='selectableCat' or @type='selectableCatWords')]//eSpan" mode="interactionCount">
		<value>1</value>
	</xsl:template>

	<xsl:template match="eSpan[not(@example='y') and not(ancestor::interactiveTextBlock/@example='y')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>
	<xsl:template match="eSpan[not(@example='y') and not(ancestor::interactiveTextBlock/@example='y')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>

	<xsl:template match="eDiv[not(@example='y')]" mode="interactionCount">
		<value>1</value>
	</xsl:template>

</xsl:stylesheet>
