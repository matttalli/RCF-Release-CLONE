<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="listenAndColour">

		<!--
			all environments except for rcf-transformation-server will validate the svg
			at transformation time - the rcf-transformation-server does not have access to the file system
			and rewriting all the location urls would be a lot of work.
		-->
		<xsl:variable name="xmlValidForSvg">
			<xsl:choose>
				<xsl:when test="$useInlineSvg='y'">
					<xsl:call-template name="validateListenAndColourSvg">
						<xsl:with-param name="listenAndColour" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<!-- if svg not valid, then output the errors -->
			<xsl:when test="not($xmlValidForSvg='')">
				<xsl:copy-of select="$xmlValidForSvg"/>
			</xsl:when>
			<!-- otherwise, output the rest of the html for the interaction -->
			<xsl:otherwise>
				<!-- build a list of the clickable svgElement ids -->
				<xsl:variable name="svgElements">
					<xsl:for-each select="itemGroups//item[not(@example='y')]"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:for-each>
				</xsl:variable>

				<!-- output interaction definition html element -->
				<div data-rcfinteraction="listenAndColour" data-rcfid="{@id}" data-svgElements="{normalize-space($svgElements)}" class="listenAndColour {@class}" >
					<!-- palette first -->
					<xsl:apply-templates select="colourPalette"/>
					<!-- svg contents next -->
					<xsl:apply-templates select="itemGroups"/>
					<!-- audio block at the bottom -->
					<xsl:apply-templates select="audio"/>
				</div>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- output the large audio player -->
	<xsl:template match="listenAndColour/audio">
		<div class="listenAndColourAudioContainer">
			<xsl:apply-templates select="." mode="fullPlayer"/>
		</div>
	</xsl:template>

	<!-- output the colour palette -->
	<xsl:template match="listenAndColour/colourPalette">
		<xsl:variable name="allColourClasses">
			<xsl:for-each select="colour"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:for-each>
		</xsl:variable>
		<div class="listenAndColourPalette" data-allcolours="{normalize-space($allColourClasses)}">
			<ol class="coloursContainer">
				<xsl:apply-templates/>
				<li class="colourPaletteItem eraser"></li>
			</ol>
		</div>
	</xsl:template>

	<xsl:template match="listenAndColour/colourPalette/colour">
		<xsl:variable name="colourValue" select="@name"/>
		<xsl:variable name="svgParent"><xsl:value-of select="ancestor::listenAndColour//itemGroups/items[@correctColour=$colourValue]/@id"/></xsl:variable>

		<xsl:variable name="isDistractor"><xsl:if test="count(ancestor::listenAndColour//itemGroups/items[@correctColour=$colourValue])=0 or (count(ancestor::listenAndColour/itemGroups/items[@id=$svgParent]/item[@example='y']) = count(ancestor::listenAndColour/itemGroups/items[@id=$svgParent]/item))">y</xsl:if></xsl:variable>

		<xsl:variable name="distractorClass"><xsl:if test="$isDistractor='y'">distractor</xsl:if></xsl:variable>

		<xsl:variable name="svgExampleElements">
			<xsl:for-each select="ancestor::listenAndColour/itemGroups/items[@id=$svgParent]/item[@example='y']">
				<xsl:value-of select="@name"/><xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>

		<li class="colourPaletteItem {@name} {$distractorClass}" data-colourvalue="{@name}" >
			<xsl:if test="not($svgParent='')">
				<xsl:attribute name="data-svgParent"><xsl:value-of select="$svgParent"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not(normalize-space($svgExampleElements)='')">
				<xsl:attribute name="data-svgExampleElements"><xsl:value-of select="normalize-space($svgExampleElements)"/></xsl:attribute>
			</xsl:if>
			<span class="mark">&#160;&#160;&#160;</span>
		</li>

	</xsl:template>

	<!-- output the container and the svg here if required -->
	<xsl:template match="itemGroups">
		<xsl:variable name="svgFile">
			<xsl:choose>
				<xsl:when test="$useInlineSvg='y'">
					<xsl:call-template name="getSvgLocation">
						<xsl:with-param name="env" select="$environment"/>
						<xsl:with-param name="svgHost" select="$host"/>
						<xsl:with-param name="svgPath" select="$svgFilePath"/>
						<xsl:with-param name="svgName" select="@svg"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="@svg"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--
			escape any '-' characters in the file name when we output the xsl comment replaces the dash with an em-dash

			Unfortunately, xspec strips out comments / escapes double dashes in comments so we can't test this
		-->
		<xsl:variable name="translateFrom" select="'-'"/>
		<xsl:variable name="translateTo" select="'—'"/>

		<xsl:comment>svgFileName:<xsl:value-of select="translate($svgFile, $translateFrom, $translateTo)"/></xsl:comment>

		<div class="listenAndColourSvgContainer">
			<xsl:choose>
				<xsl:when test="$useInlineSvg='y'">
					<xsl:copy-of select="document($svgFile)"/>
				</xsl:when>
				<xsl:otherwise>
					<img src="{$svgFile}" class="dev-inline-svg" />
				</xsl:otherwise>
			</xsl:choose>
		</div>

	</xsl:template>

	<!-- rcf_listen_and_colour -->
	<xsl:template match="listenAndColour" mode="getRcfClassName">
		rcfListenAndColour
	</xsl:template>

</xsl:stylesheet>
