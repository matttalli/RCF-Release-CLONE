<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
	markingGuidance (inside a writing interaction)
-->

	<!-- standard answer model output - as an 'answer-key' -->
	<xsl:template match="markingGuidance" mode="outputOpenGradableMarkingGuidance">
		<div class="block markingGuidanceBlock">
			<p>
				<xsl:apply-templates />
			</p>
		</div>
	</xsl:template>

	<xsl:template match="text()" mode="outputOpenGradableMarkingGuidance"/>

</xsl:stylesheet>
