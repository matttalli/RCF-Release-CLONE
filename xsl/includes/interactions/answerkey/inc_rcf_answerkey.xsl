<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>

	<xsl:template match="answerKey">
		<xsl:variable name="className">answerKeyList vertical<xsl:if test="@type"><xsl:text> </xsl:text><xsl:value-of select="@type"/></xsl:if><xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if></xsl:variable>

		<div data-rcfinteraction="answerKey" data-rcfid="{@id}">
			<xsl:choose>
				<xsl:when test="count(item) &gt; 0">
					<xsl:choose>
						<xsl:when test="@type='numbered' or @type='alpha' or @type='upper-alpha' or @type='roman'">
							<ol class="{$className}">
								<xsl:if test="@start">
									<xsl:attribute name="start"><xsl:value-of select="@start"/></xsl:attribute>
								</xsl:if>
								<xsl:apply-templates/>
							</ol>
						</xsl:when>
						<xsl:otherwise>
							<ul class="{$className}">
								<xsl:apply-templates />
							</ul>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</div>

	</xsl:template>

	<xsl:template match="answerKey//item">
		<xsl:variable name="listItemClassName"><xsl:if test="@numbered='n'">unnumbered</xsl:if></xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example selected</xsl:if></xsl:variable>
		<xsl:variable name="spanClassName">answerKey answerKeyItem selectable<xsl:if test="@example='y'"><xsl:text> </xsl:text>selected example</xsl:if></xsl:variable>
		<xsl:variable name="startNum">
			<xsl:choose>
				<xsl:when test="../@start"><xsl:value-of select="../@start"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li>
			<xsl:if test="$listItemClassName!=''">
				<xsl:attribute name="class"><xsl:value-of select="$listItemClassName"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not (@numbered='n')">
				<xsl:attribute name="value"><xsl:value-of select="count(preceding-sibling::item[not(@numbered='n')])+($startNum)"/></xsl:attribute>
			</xsl:if>
			<span class="{normalize-space(concat('answerKey answerKeyItem selectable ', @class, ' ' , $exampleClass))}" data-rcfid="{@id}">
				<xsl:apply-templates/>
			</span>
		</li>
	</xsl:template>

	<xsl:template match="answerKey//block">
		<div class="block">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="answerKey//answerKeyBlock">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example selected</xsl:if></xsl:variable>
		<div class="{normalize-space(concat('answerKeyBlock answerKey selectable ', @class, ' ', $exampleClass))}" data-rcfid="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="answerKey//answerKeyItem">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example selected</xsl:if></xsl:variable>
		<span class="{normalize-space(concat('answerKeyItem answerKey selectable ', @class, ' ', $exampleClass))}" data-rcfid="{@id}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="answerKey" mode="getUnmarkedInteractionName">
		rcfAnswerKey
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
