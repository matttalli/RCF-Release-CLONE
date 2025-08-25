<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!--
		*******************************************************************************************
			page includes
		*******************************************************************************************
	-->
	<!-- utils -->
	<xsl:include href="./inc_utils.xsl"/>
	<!-- handle page scoring / determination -->
	<xsl:include href="./scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl" />
	<!-- multimedia elements -->
	<xsl:include href="./interactions/audio/inc_rcf_audio.xsl"/>
	<xsl:include href="./interactions/video/inc_rcf_video.xsl"/>
	<!-- markup items -->
	<xsl:include href="./markup/inc_rcf_markup.xsl" />
	<xsl:include href="./inc_rcf_url_utils.xsl"/>
	<xsl:include href="./interactions/utils/inc_html_classes_utils.xsl"/>

	<!-- block level elements for layout -->
	<xsl:include href="./wordbox/inc_rcf_wordbox.xsl"/>
	<xsl:include href="./markup/blockElements/inc_rcf_block_elements.xsl"/>
	<xsl:include href="./interactions/inc_determineInteractions.xsl"/>

</xsl:stylesheet>
