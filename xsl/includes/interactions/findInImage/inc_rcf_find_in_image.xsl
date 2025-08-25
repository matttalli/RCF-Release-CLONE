<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="findInImage">
		<xsl:variable name="xmlValidForSvg">
			<xsl:choose>
				<xsl:when test="$useInlineSvg='y'">
					<xsl:call-template name="validateFindInImageSvg">
						<xsl:with-param name="findInImage" select="."/>
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
					<xsl:for-each select="items/item"><xsl:value-of select="@id"/><xsl:text> </xsl:text></xsl:for-each>
				</xsl:variable>

				<xsl:variable name="numQuestions">
					<xsl:choose>
						<xsl:when test="@play"><xsl:value-of select="@play"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="count(questions/question)"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- output interaction html -->
				<div data-rcfinteraction="findInImage"
					data-rcfid="{@id}"
					data-ignoreNextAnswer="y"
					data-numberOfQuestionsToPlay="{$numQuestions}"
					data-mode="{@mode}"
					data-svgElements="{normalize-space($svgElements)}"
					class="{normalize-space(concat('findInImage', ' ', @class))}"
				>
					<!-- no more coverscreens for findInImage -->

					<xsl:call-template name="findInImageGameOverScreen" />
					<!-- if there *IS* a coverscreen, do not process it -->
					<xsl:apply-templates select="*[not(self::coverScreen)]"/>

					<!-- output our 'fake' coverscreen, just a button at the bottom -->
					<xsl:call-template name="findInImageStartScreen"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="findInImage/scene">
		<xsl:variable name="svgFileName">
			<xsl:choose>
				<xsl:when test="$useInlineSvg='y'">
					<xsl:call-template name="getSvgLocation">
						<xsl:with-param name="env" select="$environment"/>
						<xsl:with-param name="svgHost" select="$host"/>
						<xsl:with-param name="svgPath" select="$svgFilePath"/>
						<xsl:with-param name="svgName" select="@src"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$levelAssetsURL"/>/images/<xsl:value-of select="@src"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--
			escape any '-' characters in the file name when we output the xsl comment replaces the dash with an em-dash

			Unfortunately, xspec strips out comments / escapes double dashes in comments so we can't test this
		-->
		<xsl:variable name="translateFrom" select="'-'"/>
		<xsl:variable name="translateTo" select="'—'"/>

		<xsl:comment>svgFileName:<xsl:value-of select="translate($svgFileName, $translateFrom, $translateTo)"/></xsl:comment>

		<div class="findInImageContainer">
			<xsl:choose>
				<xsl:when test="$useInlineSvg='y'">
					<xsl:if test="$svgFileName!=''">
						<xsl:copy-of select="document($svgFileName)"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<img src="{$svgFileName}" class="dev-inline-svg"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="findInImage/questions">
		<div class="dev-prompts">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- fallback start/cover screen when nothing specified in the interaction xml -->
	<xsl:template name="findInImageStartScreen">
		<div class="stagingScreen findInImageStartScreen">
			<button
				class="startGameButton"
				data-rcfTranslate=""
				aria-label="[ components.button.start ]"
			>[ components.button.start ]</button>
		</div>
	</xsl:template>

	<!-- fallback game over screen when nothing specified in the interaction xml -->
	<xsl:template name="findInImageGameOverScreen">
		<div class="stagingScreen findInImageGameOverScreen">
			<button
				class="replayGameButton"
				data-rcfTranslate=""
				aria-label="[ components.button.replayGame ]"
			>[ components.button.replayGame ]</button>
		</div>
	</xsl:template>

	<!-- rcf_findinimage -->
	<xsl:template match="findInImage" mode="getRcfClassName">
		rcfFindInImage
	</xsl:template>

</xsl:stylesheet>
