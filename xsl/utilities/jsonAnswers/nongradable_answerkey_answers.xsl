<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="answerKey" mode="outputAnswers">
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "answerKey",
			"markType": "unmarked",
			"markedBy": "nobody",
			"value": [
				<xsl:apply-templates mode="outputAnswerKeyAnswers"/>
			]
		}
	</xsl:template>

	<!-- don't output answers for examples -->
	<xsl:template match="answerKey/item[not(@example='y')]" mode="outputAnswerKeyAnswers">
		<xsl:variable name="currentAnswerKeyId" select="../@id"/>
		<!-- output a , if there are more answerKey/item elements which are not examples -->
		"<xsl:value-of select="@id"/>"<xsl:if test="count(following::item[not(@example='y') and ../@id=$currentAnswerKeyId]) &gt; 0">,</xsl:if>
	</xsl:template>

	<!-- don't output answers for examples -->
	<xsl:template match="answerKeyItem[not(@example='y')] | answerKeyBlock[not(@example='y')]" mode="outputAnswerKeyAnswers">
		<xsl:variable name="currentAnswerKeyId" select="ancestor::answerKey/@id"/>
		<!-- output a , if there are more answerKeyItem or answerKeyBlock elements which are not examples -->
		"<xsl:value-of select="@id"/>"<xsl:if test="count(following::answerKeyItem[not(@example='y') and ancestor::answerKey/@id=$currentAnswerKeyId]) + count(following::answerKeyBlock[not(@example='y') and ancestor::answerKey/@id=$currentAnswerKeyId]) &gt; 0">,</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="outputAnswerKeyAnswers"/>

</xsl:stylesheet>
