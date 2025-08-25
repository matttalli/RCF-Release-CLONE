<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="presentation">
		<xsl:variable name="classNames">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select=".//main"/>
			</xsl:call-template>
		</xsl:variable>

		<section>
			<xsl:attribute name="class"><xsl:value-of select="normalize-space(concat('block mm_presentation presentation ', @class, ' ', $classNames))"/></xsl:attribute>
			<xsl:if test="@referenceId and not(@referenceId = '')">
				<xsl:attribute name="data-rcfReferenceContentId"><xsl:value-of select="@referenceId"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</section>

	</xsl:template>

	<xsl:template match="presentation/referenceContent">
		<!-- generate an id for the collapsible block controls to work with -->
		<xsl:variable name="childBlockId"><xsl:value-of select="ancestor::activity/@id"/>_<xsl:value-of select="@id"/></xsl:variable>

		<!-- build the reference content html and place into a variable -->
		<xsl:variable name="presentationContent">
			<div class="block referenceContentBlock" id="{$childBlockId}">
				<xsl:if test="@lang">
					<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="main" />
			</div>
		</xsl:variable>

		<xsl:variable name="title">
			<xsl:value-of select="metadata/title/text()" />
		</xsl:variable>

		<xsl:variable name="titleLang">
			<xsl:choose>
				<xsl:when test="metadata/title/@lang">
					<xsl:value-of select="metadata/title/@lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@lang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- call the new collapsible block named template in xsl/includes/markup/blockElements/collapsibleBlock/inc_rcf_collapsibleblock.xsl -->
		<xsl:call-template name="outputCollapsibleBlock">
			<!-- pass the content variable to be output -->
			<xsl:with-param name="contents" select="$presentationContent"/>
			<!-- pass the block id to be used for the collapsible block -->
			<xsl:with-param name="childBlockId" select="$childBlockId"/>
			<!-- pass any extra class name we want on the container -->
			<xsl:with-param name="className" select="'referenceContent'"/>
			<!-- pass any title we want on the container / buttons -->
			<xsl:with-param name="title" select="$title"/>
			<!-- pass titleLang attribute if present -->
			<xsl:with-param name="titleLang" select="$titleLang"/>
			<!-- pass any open / closed captions for the collapsible block button -->
			<xsl:with-param name="captionWhenOpen" select="'[ interactions.presentationWithReferenceContent.whenOpened ]'"/>
			<xsl:with-param name="captionWhenClosed" select="'[ interactions.presentationWithReferenceContent.whenClosed ]'"/>
			<!-- pass an initial open state -->
			<xsl:with-param name="isOpen" select="'n'"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template match="presentation/referenceContent/main">
		<!-- make sure we don't match the 'main' template for activities -->
		<xsl:apply-templates/>
	</xsl:template>

 	<xsl:template match="presentation/referenceContent" mode="getUnmarkedInteractionName">
		rcfCollapsibleBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
