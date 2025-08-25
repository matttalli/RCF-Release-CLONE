<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexDroppableBlock">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="wordList">
		<!-- output wordbox -->
		<div class="rcfPrint-wordBox">
			<ul>
				<xsl:for-each select="./item">
					<li data-rcfid="{@id}">
						<xsl:if test="./image or ./imageAudio">
							<xsl:attribute name="class"><xsl:if test="./image">rcfPrint-hasImage</xsl:if><xsl:if test="./imageAudio">rcfPrint-hasImageAudio</xsl:if></xsl:attribute>
						</xsl:if>
						<xsl:apply-templates/>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="complexDroppables">
		<!-- no output for this element -->
	</xsl:template>

	<xsl:template match="complexDroppable">
		<xsl:variable name="className"><xsl:if test="@example='y'"> rcfPrint-example</xsl:if></xsl:variable>

		<span data-rcfid="{@id}" class="{normalize-space(concat(@printClass, ' ', $className))}">
			<xsl:call-template name="outputPrintNumber"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="complexDroppable/item[1]">
		<xsl:variable name="itemId" select="./@id"/>
		<xsl:variable name="longestItem"><xsl:value-of select="ancestor::complexDroppableBlock/@longestItem"/></xsl:variable>
		<xsl:variable name="longestItemLength"><xsl:value-of select="string-length($longestItem)"/></xsl:variable>
		<xsl:variable name="hasImage"><xsl:value-of select="boolean(ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]/descendant-or-self::image)"/></xsl:variable>
		<xsl:variable name="hasImageAudio"><xsl:value-of select="boolean(ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]/descendant-or-self::imageAudio)"/></xsl:variable>
		<xsl:variable name="className">rcfPrint-dragTarget<xsl:if test="../@example='y' and $hasImage='true'"> rcfPrint-hasImage</xsl:if><xsl:if test="../@example='y' and $hasImageAudio='true'"> rcfPrint-hasImageAudio</xsl:if></xsl:variable>

		<span class="{$className}">
			<xsl:choose>
				<xsl:when test="../@example='y'">
					<xsl:attribute name="data-rcfid">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<!-- output example -->
					<xsl:choose>
						<xsl:when test="$hasImage='true'">
							<xsl:apply-templates select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]/descendant-or-self::image"/>
						</xsl:when>
						<xsl:when test="$hasImageAudio='true'">
							<xsl:apply-templates select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]/descendant-or-self::imageAudio"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="exampleText"><xsl:value-of select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]"/></xsl:variable>
							<input type="text" size="{$longestItemLength}" value="{$exampleText}" disabled="disabled"/>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:when>
				<xsl:otherwise>
					<!-- output wol -->
					<input type="text" size="{$longestItemLength * 2}" disabled="disabled"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>

	<!-- answer key output for <complexDroppable> -->
	<xsl:template match="li//complexDroppable[not(@example='y')]" mode="outputAnswerKey">
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer</xsl:variable>
			<span class="{normalize-space($className)}" data-rcfid="{@id}">
				<xsl:for-each select="item">
					<xsl:variable name="itemId" select="@id"/>
					<span class="rcfPrint-item" data-rcfid="{@id}">
						<xsl:apply-templates select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]"/>
						<xsl:if test="position()!=last()"><xsl:call-template name="outputAnswerKeyPrintSeparator"/></xsl:if>
					</span>
				</xsl:for-each>
			</span>
	</xsl:template>

	<xsl:template match="complexDroppable[not(@example='y')]" mode="outputAnswerKeyValueForInteraction">
		<xsl:variable name="className"><xsl:value-of select="@printClass"/> rcfPrint-answer</xsl:variable>
			<span class="{normalize-space($className)}" data-rcfid="{@id}">
				<xsl:for-each select="item">
					<xsl:variable name="itemId" select="@id"/>
					<span class="rcfPrint-item" data-rcfid="{@id}">
						<xsl:apply-templates select="ancestor::complexDroppableBlock/complexDroppables/item[@id=$itemId]"/>
						<xsl:if test="position()!=last()"><xsl:call-template name="outputAnswerKeyPrintSeparator"/></xsl:if>
					</span>
				</xsl:for-each>
			</span>
	</xsl:template>

</xsl:stylesheet>
