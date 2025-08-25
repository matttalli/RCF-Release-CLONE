<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="dropDown[@isInteraction='y' and @printType='inline']">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'"> rcfPrint-example</xsl:if></xsl:variable>
		<span class="{@printClass}{$exampleClass}" data-rcfid="{@id}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dropDown[@isInteraction='y' and @printType='inline']/item">
		<xsl:variable name="className">rcfPrint-item <xsl:if test="../@example='y' and @correct='y'">rcfPrint-correct</xsl:if></xsl:variable>
		<xsl:variable name="isFirstAnswerOutput"><xsl:if test="count(preceding-sibling::item)=0">y</xsl:if></xsl:variable>

		<span class="{normalize-space($className)}" data-rcfid="{@id}">
			<xsl:if test="$isFirstAnswerOutput='y' and not(preceding-sibling::prefix)">
				<xsl:call-template name="outputPrintNumber"/>
			</xsl:if>
			<span class="rcfPrint-text">
				<xsl:apply-templates/>
			</span>
			<xsl:if test="count(following-sibling::item)>0">
				<xsl:call-template name="outputPrintSeparator"/>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="dropDown[@isInteraction='y' and @printType='inline']/prefix">
		<span class="rcfPrint-prefix">
			<xsl:call-template name="outputPrintNumber"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<!-- answer key output for <dropDown> -->
	<xsl:template match="dropDown" mode="outputAnswerKeyValueForInteraction">
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer</xsl:variable>
		<xsl:if test="not(@example='y')">
			<span class="{normalize-space($className)}" data-rcfid="{@id}">
				<xsl:for-each select="item[@correct='y']">
					<span class="rcfPrint-item" data-rcfid="{@id}">
						<xsl:apply-templates/>
						<xsl:if test="position()!=last()"><xsl:call-template name="outputAnswerKeyPrintSeparator"/></xsl:if>
					</span>
				</xsl:for-each>
			</span>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
