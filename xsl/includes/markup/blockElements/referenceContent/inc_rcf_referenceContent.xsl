<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="referenceContent">
		<xsl:choose>
			<xsl:when test="ancestor::activity">
				<xsl:apply-templates select="." mode="outputBlock" />
			</xsl:when>
			<xsl:otherwise>
				<div class="referenceContentContainer">
 					<xsl:apply-templates select="." mode="outputBlock"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="referenceContent" mode="outputBlock">
		<xsl:variable name="initialClass">
			<xsl:if test="ancestor::collapsibleBlock">
				<xsl:choose>
					<xsl:when test="not(ancestor::collapsibleBlock/@open='n')">collapsibleOpen</xsl:when>
					<xsl:otherwise>collapsibleClosed</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>

		<div id="{@id}" data-rcfxmlid="{@id}"
			class="{normalize-space(concat('dev-rcf-content referenceContent ', @type, ' ', @class, ' clearfix ', $initialClass))}"
		>
			<xsl:attribute name="data-gradableType">non-gradable</xsl:attribute>

			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="not(ancestor::activity)">
				<xsl:attribute name="data-environment"><xsl:value-of select="$environment"/></xsl:attribute>
				<xsl:attribute name="data-sharedassetsurl"><xsl:value-of select="$sharedAssetsURL"/></xsl:attribute>
				<xsl:attribute name="data-levelassetsurl"><xsl:value-of select="$levelAssetsURL"/></xsl:attribute>
				<xsl:attribute name="data-unmarkedInteractions">
					<xsl:call-template name="getUnmarkedInteractionsInElement">
						<xsl:with-param name="rootNode" select="."/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:if test="metadata/title">
					<xsl:attribute name="data-title"><xsl:value-of select="metadata/title"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="metadata/title/@lang">
					<xsl:attribute name="data-title-lang"><xsl:value-of select="metadata/title/@lang"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="metadata/type">
					<xsl:attribute name="data-type">
						<xsl:for-each select="metadata/type/content">
							<xsl:value-of select="@type"/>
							<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="data-recallable"><xsl:value-of select="metadata/recallable/@value"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			<div class="activityAudioPlayerContainer audioContainer">
				<audio id="{@id}_activityAudioPlayer" class="activityAudioPlayer" crossorigin="" playsinline="" preload="auto" nocontrols=""/>
			</div>
			<!-- output the contents of the reference content -->
			<xsl:apply-templates/>

		</div>
	</xsl:template>

	<xsl:template match="referenceContent/metadata/title">
		<!-- ignored for now -->
	</xsl:template>

</xsl:stylesheet>
