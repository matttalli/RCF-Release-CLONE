<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- output 'blockset' style blocks -->
	<xsl:template match="block[@blockSet='y']">
		<xsl:variable name="initialClass">
			<xsl:if test="ancestor::collapsibleBlock">
				<xsl:choose>
					<xsl:when test="not(ancestor::collapsibleBlock/@open='n')">collapsibleOpen</xsl:when>
					<xsl:otherwise>collapsibleClosed</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<div class="blockSet {@class} {$initialClass}">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:if test="@equaliseHeight='y'">
				<xsl:attribute name="data-equaliseHeight">y</xsl:attribute>
			</xsl:if>
			<xsl:if test="./@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>

			<!-- output wordBox if necessary -->
			<xsl:call-template name="outputWordBoxForBlockLevelInteractions"/>

			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- output blocks with 'columns' -->
	<xsl:template match="block[ count(block[@column='y'])>0 ]">
		<xsl:variable name="numCols"><xsl:value-of select="count(block[@column='y'])"/></xsl:variable>
		<xsl:variable name="initialClass">
			<xsl:if test="ancestor::collapsibleBlock">
				<xsl:choose>
					<xsl:when test="not(ancestor::collapsibleBlock/@open='n')">collapsibleOpen</xsl:when>
					<xsl:otherwise>collapsibleClosed</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
 		<div id="{@id}" class="block columns{$numCols} {@class} {$initialClass} clearfix">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:if test="@equaliseHeight='y'">
				<xsl:attribute name="data-equaliseHeight">y</xsl:attribute>
			</xsl:if>

			<!-- output wordBox if necessary -->
			<xsl:call-template name="outputWordBoxForBlockLevelInteractions"/>

			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- output 'standard' blocks -->
	<xsl:template match="block">

		<xsl:if test="@equaliseHeight='y'">
			<xsl:attribute name="data-equaliseHeight">y</xsl:attribute>
		</xsl:if>

		<!-- output wordBox if necessary -->
		<xsl:call-template name="outputWordBoxForBlockLevelInteractions"/>

		<!-- now create the standard 'block' -->
		<xsl:variable name="blockClass">
			<xsl:choose>
				<xsl:when test="@column='y'">col block col<xsl:value-of select="count(preceding-sibling::block[@column='y'])+1"/></xsl:when>
				<xsl:otherwise>block</xsl:otherwise>
			</xsl:choose><xsl:if test="ancestor::carousel"> item </xsl:if>
		</xsl:variable>

		<xsl:variable name="initialClass">
			<xsl:if test="ancestor::collapsibleBlock">
				<xsl:choose>
					<xsl:when test="not(ancestor::collapsibleBlock/@open='n')">collapsibleOpen</xsl:when>
					<xsl:otherwise>collapsibleClosed</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>

		<div class="{normalize-space(concat($blockClass, ' ', @class, ' ', $initialClass, ' ', 'clearfix'))}">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@triggerClass">
				<xsl:attribute name="data-rcfinteraction">triggerableElement</xsl:attribute>
				<xsl:attribute name="data-rcfInitialisePriority">-1</xsl:attribute>
				<xsl:attribute name="data-ignoreNextAnswer">y</xsl:attribute>
				<xsl:attribute name="data-triggerable">y</xsl:attribute>
				<xsl:attribute name="data-triggerClass"><xsl:value-of select="@triggerClass"/></xsl:attribute>
				<xsl:attribute name="data-triggerLoop"><xsl:value-of select="@triggerLoop"/></xsl:attribute>
				<xsl:attribute name="data-triggerNumber"><xsl:value-of select="@triggerNumber"/></xsl:attribute>
				<xsl:attribute name="data-triggerExclusive"><xsl:value-of select="@triggerExclusive"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:choose>
				<xsl:when test="parent::collapsibleBlock">
					<xsl:attribute name="id">
						<xsl:call-template name="generateId">
							<xsl:with-param name="element" select="parent::collapsibleBlock"/>
						</xsl:call-template>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@id">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</div>

	</xsl:template>

	<xsl:template name="outputWordBoxForBlockLevelInteractions">
		<!-- if wordboxposition='top', it will already have been written out ! -->
		<xsl:if test="$wordBoxPosition='default'">
			<xsl:variable name="firstDroppableBlockUID"><xsl:value-of select="generate-id(ancestor::activity/.//block[.//droppable])"/></xsl:variable>
			<xsl:variable name="droppableBlockUID"><xsl:value-of select="generate-id()"/></xsl:variable>

			<xsl:variable name="outputWordBox">
				<xsl:choose>
					<xsl:when test="count(//splitBlock)>0">N</xsl:when>
					<xsl:when test="count(.//droppable)>0 and $firstDroppableBlockUID=$droppableBlockUID">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$outputWordBox='Y'">

				<xsl:call-template name="standardWordBox">
					<xsl:with-param name="activity" select="ancestor::activity"/>
					<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
					<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
