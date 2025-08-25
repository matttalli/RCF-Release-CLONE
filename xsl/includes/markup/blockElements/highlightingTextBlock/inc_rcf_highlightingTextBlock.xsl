<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- highlighting text block -->
	<xsl:template match="highlightingTextBlock">
		<!-- if this is the first highlighting text block in the document, add the tools -->
		<xsl:if test="count(preceding::highlightingTextBlock)=0">
			<xsl:call-template name="outputHighlightingToolBar"/>
		</xsl:if>

		<!-- output the highlighting text block html -->
		<div
			data-rcfinteraction="highlightingTextBlock"
			data-ignoreNextAnswer="y"
			class="{normalize-space(concat('highlightingTextBlock ', @class))}"
			data-rcfid="{@id}"

			>
			<!-- standard block content - let the other templates output the contents -->
			<xsl:apply-templates/>
		</div>

	</xsl:template>

	<xsl:template name="outputHighlightingToolBar">
		<div class="highlighterToolbarContainer">
			<div class="highlighterToolbar">
				<button class="showToolsButton" tabindex="0" role="button" type="button"
					data-rcfTranslate=""
					aria-label="[ interactions.highlightingTextBlock.toolsButtonClosed ]"
					>
					<svg xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 22 22"
						fill="none"
						class="openTools"
						>
						<path d="M20 20H12M1.5 20.5L7.04927 18.3656C7.40421 18.2291 7.58168 18.1609 7.74772 18.0717C7.8952 17.9926 8.0358 17.9012 8.16804 17.7986C8.31692 17.683 8.45137 17.5486 8.72028 17.2797L20 5.99997C21.1046 4.8954 21.1046 3.10454 20 1.99997C18.8955 0.895398 17.1046 0.895397 16 1.99996L4.72028 13.2797C4.45138 13.5486 4.31692 13.683 4.20139 13.8319C4.09877 13.9642 4.0074 14.1048 3.92823 14.2523C3.83911 14.4183 3.77085 14.5958 3.63433 14.9507L1.5 20.5ZM1.5 20.5L3.55812 15.1489C3.7054 14.766 3.77903 14.5745 3.90534 14.4869C4.01572 14.4102 4.1523 14.3812 4.2843 14.4064C4.43533 14.4353 4.58038 14.5803 4.87048 14.8704L7.12957 17.1295C7.41967 17.4196 7.56472 17.5647 7.59356 17.7157C7.61877 17.8477 7.58979 17.9843 7.51314 18.0947C7.42545 18.221 7.23399 18.2946 6.85107 18.4419L1.5 20.5Z" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
					</svg>

					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke-width="1.5"
						stroke="currentColor"
						class="closeTools"
						>
						<path stroke-linecap="round" stroke-linejoin="round" d="M11.25 4.5l7.5 7.5-7.5 7.5m-6-15l7.5 7.5-7.5 7.5" />
					</svg>
				</button>
				<!-- tools area -->
				<div class="highlighterColorTools">
					<button tabindex="0" type="button" data-rcfColorClass="highlighting-color1" data-rcfTranslate="" aria-label="[ interactions.highlightingTextBlock.colorButton1Caption ]" class="toolbarButtonColor highlighting-color1 active"></button>
					<button tabindex="0" type="button" data-rcfColorClass="highlighting-color2" data-rcfTranslate="" aria-label="[ interactions.highlightingTextBlock.colorButton2Caption ]" class="toolbarButtonColor highlighting-color2"></button>
					<button tabindex="0" type="button" data-rcfColorClass="highlighting-color3" data-rcfTranslate="" aria-label="[ interactions.highlightingTextBlock.colorButton3Caption ]" class="toolbarButtonColor highlighting-color3"></button>
					<button tabindex="0" type="button" data-rcfColorClass="highlighting-color4" data-rcfTranslate="" aria-label="[ interactions.highlightingTextBlock.colorButton4Caption ]" class="toolbarButtonColor highlighting-color4"></button>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="highlightingTextBlock" mode="getUnmarkedInteractionName">
		rcfHighlightingTextBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
