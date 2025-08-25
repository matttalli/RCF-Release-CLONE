<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="itemRadio[@displayType='itemSelect']">

		<xsl:variable name="interactionClassValue">
			radioItemSelect itemRadioItemSelect answers<xsl:value-of select="count(item)"/><xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
				<xsl:otherwise>horizontal</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@type"><xsl:text> </xsl:text><xsl:value-of select="@type"/><xsl:text> </xsl:text></xsl:if>
			<xsl:if test="@example='y'"><xsl:text> </xsl:text>example<xsl:text> </xsl:text></xsl:if>
			<xsl:if test="count(.//image) + count(.//imageAudio) > 0"><xsl:text> </xsl:text>hasImageAnswers</xsl:if>
			<xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/><xsl:text> </xsl:text></xsl:if>
		</xsl:variable>

		<span id="{@id}" data-rcfid="{@id}" data-rcfinteraction="radioItemSelect" class="{normalize-space($interactionClassValue)}" role="radiogroup">
			<xsl:if test="not(@example='y') and not(@marked='n') and count(item[@correct='y']) &gt; 0 and not(ancestor::activity/@marked='n')">
				<xsl:attribute name="data-requires-answers">y</xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'">
				<xsl:attribute name="data-rcfxlocation">
					<xsl:call-template name="genPath"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="itemRadio[@displayType='itemSelect']/item">

		<xsl:variable name="itemClass">
			markable
			selectable
			radio
			dev-list-item
			dev-markable-container
			<xsl:if test="count(.//image) + count(.//imageAudio)>0"><xsl:text> </xsl:text>imageAnswer </xsl:if>
			<xsl:if test="(ancestor::itemRadio[@example='y'] and @correct='y')"><xsl:text> </xsl:text>selected </xsl:if>
			<xsl:text> </xsl:text><xsl:value-of select="@class"/>
		</xsl:variable>

 		<span data-rcfid="{@id}" class="{normalize-space($itemClass)}" role="radio">
			<xsl:choose>
				<xsl:when test="../@example='y' and @correct='y'">
					<xsl:attribute name="aria-checked">true</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="aria-checked">false</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(../@example='y')">
				<xsl:attribute name="tabindex">0</xsl:attribute>
			</xsl:if>

			<xsl:if test="@audio">
				<xsl:attribute name="data-audiolink">
					<xsl:value-of select="@audio"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="$authoring='Y'">
				<xsl:attribute name="data-rcfxlocation">
					<xsl:call-template name="genPath"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="@correctFeedbackAudio">
				<xsl:attribute name="data-correctfeedbackaudio">
					<xsl:value-of select="@correctFeedbackAudio"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>

			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</span>
	</xsl:template>

	<!-- rcf_itembased_radio_item_select -->
	<xsl:template match="itemRadio[@displayType='itemSelect']" mode="getItemBasedRcfClassName">
		rcfItemBasedRadioItemSelect
	</xsl:template>
</xsl:stylesheet>
