<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="video">
		<xsl:variable name="vpID">video_<xsl:value-of select="count(preceding::video)+1"/></xsl:variable>
		<xsl:variable name="switchVideo">
			<xsl:choose>
				<xsl:when test="@switchVideo"><xsl:value-of select="@switchVideo"/></xsl:when>
				<xsl:otherwise>y</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="streamingSrc">
			<xsl:choose>
				<xsl:when test="@streamingSrc"><xsl:value-of select="@streamingSrc"/></xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div
			data-rcfinteraction="videoElement"
			data-ignoreNextAnswer="y"
			src="{@src}"
			class="rcfVideo videoContainer"
		>
			<xsl:if test="@streamingSrc">
				<xsl:attribute name="data-streamingSrc"><xsl:value-of select="@streamingSrc"/></xsl:attribute>
			</xsl:if>

			<!-- output the a11ytitle here to pick up in the code later - plyr library adds buttons via code -->
			<xsl:if test="@a11yTitle">
				<xsl:attribute name="data-rcfA11ytitle"><xsl:value-of select="@a11yTitle"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@title">
				<div id="videoTitle_{$vpID}" class="videoTitle"><xsl:value-of select="@title"/></div>
			</xsl:if>
			<video
				controls=""
				playsinline=""
				poster=""
				data-switchvideo="{$switchVideo}"
			>
				<xsl:if test="count(track) &gt; 0">
					<xsl:attribute name="crossorigin"/>
				</xsl:if>
				<xsl:apply-templates/>
			</video>
		</div>
	</xsl:template>

	<xsl:template match="video/track">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="video" mode="getUnmarkedInteractionName">
        rcfVideoPlayer
	</xsl:template>

</xsl:stylesheet>
