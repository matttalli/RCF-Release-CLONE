<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="complexCategorise" mode="hybrid">
		<xsl:param name="targetDisplay" select="'desktop'"/>
		<xsl:param name="useMobileDragDrop" select="'y'"/>
		<xsl:param name="useCollapsibleWordPools" select="'n'"/>

		<xsl:variable name="categoriseInteractionClass">
			<xsl:choose>
				<xsl:when test="$useMobileDragDrop='y'">hybrid</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$targetDisplay='desktop'">draggable</xsl:when>
						<xsl:otherwise>touchable</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="interactionContentClasses">
			<xsl:call-template name="interactionContentStylingClasses">
				<xsl:with-param name="interactionElement" select="." />
			</xsl:call-template>
		</xsl:variable>

		<div data-rcfid="{@id}"
			data-rcfinteraction="categorise"
			data-rcfTargetDisplay="{$targetDisplay}"
			class="{normalize-space(concat('categorise dev-hybrid ', $interactionContentClasses, ' ', $targetDisplay, ' ', $categoriseInteractionClass, ' complexCategorise clearfix'))}"
		>
			<xsl:choose>
				<xsl:when test="@restrict='y'"><xsl:attribute name="data-restrict">y</xsl:attribute></xsl:when>
				<xsl:otherwise><xsl:attribute name="data-restrict">n</xsl:attribute></xsl:otherwise>
			</xsl:choose>

			<xsl:if test="$wordBoxPosition='top' or $wordBoxPosition='default'">
				<xsl:call-template name="categoriseWordBox">
					<xsl:with-param name="categorise" select="items"/>
					<xsl:with-param name="targetDisplay" select="$targetDisplay"/>
					<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
					<xsl:with-param name="useCollapsibleWordPools" select="$useCollapsibleWordPools"/>
				</xsl:call-template>
			</xsl:if>

			<!-- output the category 'drop-boxes' -->
			<div class="categories {$categoriseInteractionClass} categories{count(categories/category)}" >
				<xsl:for-each select="categories/category">
					<xsl:variable name="genID">category_<xsl:value-of select="$targetDisplay"/>_<xsl:value-of select="@id"/></xsl:variable>

					<div id="{$genID}" data-rcfid="{@id}" class="category" >
						<h3 class="catName"><xsl:apply-templates select="catName"/></h3>
						<div class="dropTarget rcfDroppable clickAndStickable" id="dt_{$genID}" data-categoryid="{@id}">
							<ul>
								<xsl:for-each select="item[@example='y']">
									<xsl:variable name="itemID" select="@id"/>
									<xsl:variable name="itemContentStylingClasses">
										<xsl:if test="count(ancestor::complexCategorise/items/item[@id=$itemID]//image) + count(ancestor::complexCategorise/items/item[@id=$itemID]//imageAudio) &gt; 0">dragImageItem </xsl:if>
										<xsl:call-template name="itemContentStylingClasses">
											<xsl:with-param name="itemElement" select="ancestor::complexCategorise/items/item[@id=$itemID]" />
										</xsl:call-template>
									</xsl:variable>
									<li data-rcfid="{@id}" class="{normalize-space(concat('example dragItem ', $itemContentStylingClasses))}">
										<xsl:apply-templates select="ancestor::complexCategorise/items/item[@id=$itemID]"/>
									</li>
								</xsl:for-each>

							</ul>
						</div>
					</div>
				</xsl:for-each>
			</div>

			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:call-template name="categoriseWordBox">
					<xsl:with-param name="categorise" select="items"/>
					<xsl:with-param name="targetDisplay" select="$targetDisplay"/>
					<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
					<xsl:with-param name="useCollapsibleWordPools" select="$useCollapsibleWordPools"/>
				</xsl:call-template>
			</xsl:if>

		</div>
	</xsl:template>

</xsl:stylesheet>
