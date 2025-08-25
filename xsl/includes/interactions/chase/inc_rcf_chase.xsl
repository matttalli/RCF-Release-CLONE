<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="chase">
		<div
			data-rcfinteraction="chase"
			class="chase"
		>
			<div class="textControls">
				<div class="chaseControls speedControls">
					<xsl:attribute name="data-timed"><xsl:value-of select="@timed"/></xsl:attribute>
					<xsl:attribute name="data-chasetype"><xsl:value-of select="@type"/></xsl:attribute>
					<xsl:if test="@timed='y'">
						<xsl:attribute name="data-begin"><xsl:value-of select="@begin"/></xsl:attribute>
						<xsl:attribute name="data-countdown"><xsl:value-of select="@showCountDown"/></xsl:attribute>
					</xsl:if>
					<a class="leftButton selected" href="javascript:;" data-level="400">Slow</a>
					<a class="middleButton" href="javascript:;" data-level="300">Medium</a>
					<a class="rightButton" href="javascript:;" data-level="200">Fast</a>
				</div>

				<div class="playheadControls">
					<xsl:if test="@showCountDown='y'">
						<span class="chaseCountDown" ></span>
					</xsl:if>
					<a class="play singleButton" href="javascript:;">Start</a>
					<a class="stop singleButton" href="javascript:;">Reset</a>
				</div>
			</div>

			<div class="chaseDiv">
				<xsl:apply-templates />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="chase" mode="getUnmarkedInteractionName">
		rcfChase
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
