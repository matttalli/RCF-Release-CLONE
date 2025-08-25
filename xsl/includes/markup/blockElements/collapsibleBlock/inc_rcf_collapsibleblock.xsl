<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!--
		collapsible block

		Now outputs html by calling the named template 'outputCollapsibleBlock' which can be used by other elements that require a collapsible block inside them.

	-->
	<xsl:template match="collapsibleBlock">
		<xsl:variable name="contents">
			<xsl:apply-templates />
		</xsl:variable>

		<xsl:variable name="childBlockId">
			<xsl:call-template name="generateId">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="captionWhenOpen">
			<xsl:choose>
				<xsl:when test="collapseButton/@captionWhenOpened=''">[ interactions.collapsibleBlock.whenOpened ]</xsl:when>
				<xsl:otherwise><xsl:value-of select="collapseButton/@captionWhenOpened"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="captionWhenClosed">
			<xsl:choose>
				<xsl:when test="collapseButton/@captionWhenClosed=''">[ interactions.collapsibleBlock.whenClosed ]</xsl:when>
				<xsl:otherwise><xsl:value-of select="collapseButton/@captionWhenClosed"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="outputCollapsibleBlock">
			<xsl:with-param name="contents" select="$contents"/>
			<xsl:with-param name="collapsibleBlockId" select="@id"/>
			<xsl:with-param name="childBlockId" select="$childBlockId"/>
			<xsl:with-param name="className" select="@class"/>
			<xsl:with-param name="captionWhenOpen" select="$captionWhenOpen"/>
			<xsl:with-param name="captionWhenClosed" select="$captionWhenClosed"/>
			<xsl:with-param name="isOpen" select="@open"/>
		</xsl:call-template>

	</xsl:template>

	<!-- generic 'output collapsible block' named template - currently used by presentation/referenceContent, but would be nice to use everywhere that requires one !-->
	<xsl:template name="outputCollapsibleBlock">
		<xsl:param name="contents" />
		<xsl:param name="collapsibleBlockId"/>
		<xsl:param name="childBlockId"/>
		<xsl:param name="className" />
		<xsl:param name="title"/>
		<xsl:param name="titleLang"/>
		<xsl:param name="captionWhenOpen" />
		<xsl:param name="captionWhenClosed"/>
		<xsl:param name="isOpen" select="'n'"/>

		<xsl:variable name="containerOpenClass">
			<xsl:if test="$isOpen='y'">collapsibleOpen</xsl:if>
		</xsl:variable>

		<xsl:variable name="ariaExpandedValue">
			<xsl:choose>
				<xsl:when test="$isOpen='y'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<div data-rcfinteraction="collapsibleBlock"
			data-ignoreNextAnswer="y"
			class="{normalize-space(concat('collapsibleContainer ', $className, ' ', $containerOpenClass))}"
			data-initialopen="{$isOpen}"
		>
			<xsl:if test="$collapsibleBlockId">
				<xsl:attribute name="data-rcfid"><xsl:value-of select="$collapsibleBlockId"/></xsl:attribute>
			</xsl:if>

			<span class="{normalize-space(concat('singleButton collapsibleButton ', $rippleClass))}"
				role="button"
				aria-expanded="{$ariaExpandedValue}"
				aria-controls="{$childBlockId}"
				tabindex="0"
			>
				<xsl:choose>
					<xsl:when test="$title != ''">
						<span class="whenOpened innerButtonCaption">
      						<span class="prefix" data-rcfTranslate="">[ interactions.collapsibleBlock.hide ] </span>
      						<span class="title">
								<xsl:choose>
									<xsl:when test="$titleLang != ''">
										<xsl:attribute name="lang">
											<xsl:value-of select="$titleLang"/>
										</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:value-of select="$title"/>
							</span>
   						</span>
					</xsl:when>
					<xsl:when test="$captionWhenOpen=''">
						<span class="whenOpened innerButtonCaption" data-rcfTranslate="">[ interactions.collapsibleBlock.whenOpened ]</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="whenOpened innerButtonCaption" data-rcfTranslate="">
							<xsl:value-of select="$captionWhenOpen"/>
						</span>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="$title != ''">
						<span class="whenClosed innerButtonCaption">
      						<span class="prefix" data-rcfTranslate="">[ interactions.collapsibleBlock.show ] </span>
      						<span class="title">
								<xsl:choose>
									<xsl:when test="$titleLang != ''">
										<xsl:attribute name="lang">
											<xsl:value-of select="$titleLang"/>
										</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:value-of select="$title"/>
							</span>
   						</span>
					</xsl:when>
					<xsl:when test="$captionWhenClosed=''">
						<span class="whenClosed innerButtonCaption" data-rcfTranslate="">[ interactions.collapsibleBlock.whenClosed ]</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="whenClosed innerButtonCaption" data-rcfTranslate="">
							<xsl:value-of select="$captionWhenClosed"/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</span>

			<br />
			<br />

			<!-- copy the generated contents into the collapsible block -->
			<xsl:copy-of select="$contents"/>
		</div>

	</xsl:template>

	<xsl:template match="collapsibleBlock" mode="getUnmarkedInteractionName">
		rcfCollapsibleBlock
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>

</xsl:stylesheet>
