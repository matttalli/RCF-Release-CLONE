<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--
	This file will create error messages in the HTML output when an invalid combination of rcf xml elements are used.

	These should be combinations which are allowed in the schema, but make no sense as valid content.

	eg.

	<radio>
		<item audio="coal.mp3">
			the correct answer ...
			<audio size="small">
				<track src="something-else.mp3"/>
			</audio>
		</item>
	</radio>

	the 'item' has audio to play when clicked, but also contains embedded 'small' audio player - this cannot be restricted in the schema but makes no sense from an editorial point of view.

	Also - Blame QA as they keep coming up with these scenarios ;-)

-->
	<xsl:template match="*[@audio]//imageAudio | *[@audio]//audio">
		<xsl:variable name="containingNode"><xsl:value-of select="name(ancestor::*[@audio])"/></xsl:variable>

		<div class="rcfError">
			<h1>Invalid combination</h1>
			<h2>&lt;<xsl:value-of select="name()"/>&gt; found inside parent<br/>
				&lt;<xsl:value-of select="$containingNode"/><xsl:text> </xsl:text>
				<xsl:for-each select="ancestor::*[@audio]/@*"><xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"<xsl:text> </xsl:text></xsl:for-each>&gt;</h2>
		</div>
	</xsl:template>

</xsl:stylesheet>
