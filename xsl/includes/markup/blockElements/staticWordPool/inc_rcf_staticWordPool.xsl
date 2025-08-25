<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="staticWordPool">
		<div class="{normalize-space(concat('staticWordPool wordBox ', @class))}">
			<ul class="horizontal">
				<xsl:apply-templates/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="staticWordPool/item">
		<li value="{count(preceding-sibling::item)+1}">
			<xsl:if test="@example='y'">
				<xsl:attribute name="class">example</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

</xsl:stylesheet>
