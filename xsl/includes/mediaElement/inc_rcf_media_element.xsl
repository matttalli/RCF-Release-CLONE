<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="activity/media">
		<xsl:variable name="mediaType">
			<xsl:choose>
				<xsl:when test="count(audio)>0">audio</xsl:when>
				<xsl:when test="count(video)>0">video</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<div class="media {$mediaType}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>
