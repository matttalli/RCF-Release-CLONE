<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		output the flashcard html structure

	-->
	<xsl:template match="flashcard">

		<div data-rcfinteraction="flashcard"
			data-ignoreNextAnswer="y"
			data-rcfid="{@id}"
			class="{normalize-space(concat('flashcardContainer' ,' ', @class))}"
			data-shownextbutton="{@showNext}"
			data-rcfInitialisePriority="1"
		>
			<div class="flashcard">
				<xsl:apply-templates/>
			</div>

		</div>

	</xsl:template>

	<xsl:template match="descriptors">
		<div class="flashcardMenuContainer">
			<span class="singleButton flashcardMenuButton" data-rcfTranslate="">[ interactions.flashcard.menu ]</span>
			<div class="flashcardMenu">
				<div class="flashcardMenuTitle clearfix" data-rcfTranslate="">[ interactions.flashcard.settings ]</div>
				<div class="flashcardDescriptors">
					<xsl:apply-templates/>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="descriptors/item">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 0">even</xsl:when>
				<xsl:otherwise>odd</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="onClass">
			<xsl:if test="@show='y'">selected</xsl:if>
		</xsl:variable>
		<xsl:variable name="offClass">
			<xsl:if test="not(@show='y')">selected</xsl:if>
		</xsl:variable>

		<div class="descriptorMenuItem {$class} clearfix" data-descriptorid="{@id}" data-default="{@show}">
			<span class="descriptorToggle">
				<span class="off {$offClass}" data-rcfTranslate="">[ interactions.flashcard.off ]</span>
				<span class="on {$onClass}" data-default="{@show}" data-rcfTranslate="">[ interactions.flashcard.on ]</span>
			</span>
			<span class="descriptorLabel"><xsl:apply-templates/></span>
		</div>
	</xsl:template>

	<xsl:template match="flashcard/cards">

		<div data-rcfinteraction="carousel"
			data-ignoreNextAnswer="y"
			class="rcfCarousel owl-carousel owl-theme"
			data-autoheight="n"
			data-numitems="1">
			<xsl:apply-templates select="card"/>
		</div>

	</xsl:template>

	<xsl:template match="card[ancestor::flashcard]">
		<div class="block card">
			<xsl:if test="@audio">
				<xsl:attribute name="data-audio"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="cardTitle">
		<h1 class="cardTitle">
			<xsl:if test="ancestor::card/@audio">
				<xsl:call-template name="createInlineAudioPlayer">
					<xsl:with-param name="audio" select="ancestor::card/@audio"/>
					<xsl:with-param name="audioId">flashCard_card_<xsl:value-of select="ancestor::card/@id"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>

	<xsl:template match="cardDescription">
		<div class="cardDescription"><xsl:apply-templates/></div>
	</xsl:template>

	<xsl:template match="card/definitions">
		<div class="cardDefinitionsContainer clearfix">
			<div class="definitionTools clearfix">
				<xsl:if test="ancestor::flashcard/@showNext='y'">
					<span class="singleButton nextDefinitionButton" data-rcfTranslate="">[ interactions.flashcard.showNext ]</span>
				</xsl:if>
			</div>

			<div class="cardDefinitions clearfix">
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="card/block">
		<div class="flashcardBlock block clearfix">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="definitions/item">
		<xsl:variable name="refID"><xsl:value-of select="@refID"/></xsl:variable>
		<xsl:variable name="showNowClass"><xsl:if test="ancestor::flashcard/@showNext!='y' and ancestor::flashcard/descriptors/item[@id=$refID]/@show='y'">show</xsl:if></xsl:variable>
		<div class="cardDefinition {@class} {$showNowClass}"
			data-descriptorid="{@refID}"
			data-default="{ancestor::flashcard/descriptors/item[@id=$refID]/@show}"
			data-tobedisplayed="{ancestor::flashcard/descriptors/item[@id=$refID]/@show}">
			<xsl:if test="@audio">
				<xsl:attribute name="data-audio"><xsl:value-of select="@audio"/></xsl:attribute>
			</xsl:if>
			<span class="descriptorLabel">
				<xsl:apply-templates select="ancestor::flashcard/descriptors/item[@id=$refID]" mode="outputDefinition"/>
			</span>:
			<span class="definitionLabel">
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>

	<xsl:template match="item" mode="outputDefinition">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="flashcard" mode="getUnmarkedInteractionName">
		rcfFlashcard
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
    </xsl:template>

</xsl:stylesheet>
