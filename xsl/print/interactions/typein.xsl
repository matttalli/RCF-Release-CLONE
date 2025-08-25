<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
>

	<xsl:template match="typein[@isInteraction='y' and @printType='gapfill-typein']">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'"> rcfPrint-example</xsl:if></xsl:variable>
		<span class="{@printClass}{$exampleClass}" data-rcfid="{@id}">
			<xsl:call-template name="outputPrintNumber"/>

			<!-- Output the preset answer with prefix and suffix if present -->
			<xsl:if test="preset and not(@example='y')">
				<span class="rcfPrint-preset"><xsl:value-of select="prefix/text()" />(<xsl:value-of select="preset/text()" />)<xsl:value-of select="suffix/text()" /><xsl:text> </xsl:text></span>
			</xsl:if>

			<xsl:apply-templates select="prefix"/>

			<span class="rcfPrint-item">
				<xsl:variable name="longestItem"><xsl:apply-templates select="." mode="longestItem"/></xsl:variable>
				<xsl:variable name="longestItemLength"><xsl:value-of select="string-length($longestItem)"/></xsl:variable>
				<xsl:variable name="exampleText"><xsl:if test="@example='y'"><xsl:value-of select="acceptable/item[1]"/></xsl:if></xsl:variable>

				<xsl:choose>
					<xsl:when test="@example='y'">
						<xsl:attribute name="data-rcfid">
							<xsl:value-of select="acceptable/item[1]/@id" />
						</xsl:attribute>
						<input type="text" size="{$longestItemLength}" value="{$exampleText}" disabled="disabled"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="text" size="{$longestItemLength * 2}" disabled="disabled"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>

			<xsl:apply-templates select="suffix"/>
			<xsl:apply-templates select="hint"/>
		</span>
	</xsl:template>

	<xsl:template match="typein | itemTypein" mode="longestItem">
		<xsl:choose>
			<xsl:when test="not(@expandAnswers='y')">
				<xsl:for-each select="acceptable/item">
					<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
					<xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="answers"><xsl:call-template name="expandAnswers"><xsl:with-param name="stringVal"><xsl:value-of select="acceptable/item[1]"/></xsl:with-param><xsl:with-param name="quoteAnswers" select="'n'"/></xsl:call-template></xsl:variable>
				<xsl:for-each select="str:tokenize(normalize-space($answers), '|')">
					<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
					<xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- answerkey output -->
	<xsl:template match="typein" mode="outputAnswerKeyValueForInteraction">
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer</xsl:variable>

		<xsl:if test="not(@example='y')">
			<xsl:choose>
				<xsl:when test="not(@expandAnswers='y')">
					<span class="{$className}" data-rcfid="{@id}">
						<xsl:for-each select="acceptable/item">
							<span class="rcfPrint-item" data-rcfid="{@id}">
								<xsl:value-of select="."/>
								<xsl:if test="position()!=last()"><span class="rcfPrint-separator"> / </span></xsl:if>
							</span>
						</xsl:for-each>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<!-- get the expanded answers into a tokenized variable -->
					<xsl:variable name="expandedAnswers">
						<!-- loop through each acceptable/item -->
						<xsl:for-each select="acceptable/item">
							<!-- expand the answer into (potentially) multiple answers
								- the expandAnswers template wraps each in a '|', so we need to add another '|' if there are
								  more answers in the acceptable/item list
							-->
							<xsl:call-template name="expandAnswers">
								<xsl:with-param name="stringVal"><xsl:value-of select="."/></xsl:with-param>
								<xsl:with-param name="quoteAnswers">n</xsl:with-param>
							</xsl:call-template>
							<!-- add a '|' character if more to come -->
							<xsl:if test="position()!=last()">|</xsl:if>
						</xsl:for-each>
					</xsl:variable>

					<!-- loop through each tokenized answer and wrap it in a span -->
					<span class="{$className}">
						<xsl:for-each select="str:tokenize($expandedAnswers, '|')">
							<xsl:value-of select="."/><xsl:if test="position()!=last()"><span class="rcfPrint-separator"> / </span></xsl:if>
						</xsl:for-each>
					</span>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
