<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings" exclude-result-prefixes="str"
                xmlns:exsl="http://xml.apache.org/xalan"
				version="1.0">

    <!-- HTML for typeinGroup -->
	<xsl:template match="typeinGroup">
		<!--
			<typeinGroup>
				<i>c</i>
				<typein><item>o</item></typein>
				<typein><item>l</item></typein>
				<typein><item>o</item><item>ou</item></typein>
				<b>R</b>
			</typeinGroup>
		-->
		<xsl:variable name="exampleClass">
			<xsl:choose>
				<xsl:when test="@example='y'">example</xsl:when>
				<xsl:when test="count(.//typein[@example='y']) = count(.//typein)">example</xsl:when>
			</xsl:choose>
		</xsl:variable>

		 <span
			 data-rcfid="{@id}"
			 data-rcfinteraction="typeinGroup"
			 class="{normalize-space(concat('typeinGroup', ' ', $exampleClass, ' ', @class))}"
		>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
	 		<span class="markable dev-markable-container">
	 			<xsl:apply-templates/>
	 			<span class="mark">&#160;&#160;&#160;&#160;</span>
	 		</span>
	 	</span>
	</xsl:template>

    <xsl:template match="typeinGroup//typein">

		<!-- get longest answer from inc_rcf_typein-utils.xsl -->
		<xsl:variable name="longestItem"><xsl:apply-templates select="." mode="longestItem"/></xsl:variable>

		<xsl:variable name="allAnswers">
			<xsl:choose>
				<xsl:when test="not(@expandAnswers='y')">
					<xsl:for-each select="acceptable/item"><xsl:value-of select="."/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="expandAnswers"><xsl:with-param name="stringVal"><xsl:value-of select="acceptable/item[1]"/></xsl:with-param><xsl:with-param name="quoteAnswers" select="'n'"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or ancestor::typeinGroup/@example='y'">example</xsl:if></xsl:variable>
		<!-- RCF-318 -->
		<span class="prefix"><xsl:value-of select="prefix"/></span>
		<span >
			<xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
			<input data-rcfid="{@id}" type="text"
				class="typeinGroup {$exampleClass}"
				autocomplete="off"
				autocapitalize="off"
				spellcheck="false"
				autocorrect="off"
				maxlength="{string-length($longestItem)}"
				data-longestItem="{string-length($longestItem)}"
				>
				<xsl:if test="@caseSensitive">
					<xsl:attribute name="data-casesensitive"><xsl:value-of select="@caseSensitive"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@example='y' or ancestor::typeinGroup/@example='y'"><xsl:attribute name="readonly"/><xsl:attribute name="value"><xsl:value-of select="normalize-space(acceptable/item[1]/text())"/></xsl:attribute></xsl:if>
				<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			</input>
		</span>
		<!-- RCF-318 - add suffix too ? -->
		<span class="suffix"><xsl:value-of select="suffix"/></span>
	</xsl:template>

	<!-- rcf_typein_group -->
	<xsl:template match="typeinGroup" mode="getRcfClassName">
		rcfTypeinGroup
	</xsl:template>

</xsl:stylesheet>
