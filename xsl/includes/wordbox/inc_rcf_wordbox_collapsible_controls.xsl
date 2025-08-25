<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template name="outputCollapsibleToggleButton">
		<button class="toggle-collapsibleWordBox" type="button">
			<svg viewBox="0 0 14 14" xmlns="http://www.w3.org/2000/svg">
				<g fill="none" fill-rule="evenodd">
					<path d="M3.29175 4.793c-.389.392-.389 1.027 0 1.419l2.939 2.965c.218.215.5.322.779.322s.556-.107.769-.322l2.93-2.955c.388-.392.388-1.027 0-1.419-.389-.392-1.018-.392-1.406 0l-2.298 2.317-2.307-2.327c-.194-.195-.449-.293-.703-.293-.255 0-.51.098-.703.293z" fill="#344563"></path>
				</g>
			</svg>
		</button>
	</xsl:template>

	<xsl:template name="outputCollapsiblePreviousItemButton">
		<button class="itemNavigation previousItem" data-nav-mode="previousItem" type="button">
			<span>#</span>
		</button>
	</xsl:template>

	<xsl:template name="outputCollapsibleNextItemButton">
		<button class="itemNavigation nextItem" data-nav-mode="nextItem" type="button">
			<span>#</span>
		</button>
	</xsl:template>


</xsl:stylesheet>
