<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template name="categoriseWordBox">
		<xsl:param name="categorise"/>
		<xsl:param name="targetDisplay" select="'desktop'"/>
		<xsl:param name="useFixedWordPools" select="'n'"/>
		<xsl:param name="useCollapsibleWordPools" select="'n'"/>
		<xsl:variable name="fixedWordBoxClass"><xsl:if test="$useFixedWordPools='y'">fixedWordBox</xsl:if></xsl:variable>
		<xsl:variable name="collapsibleWordBoxClass"><xsl:if test="$useCollapsibleWordPools='y'">collapsibleWordBox collapsed</xsl:if></xsl:variable>

		<!-- output selectable wordBox -->
		<div class="{normalize-space(concat('wordBox', ' ', $fixedWordBoxClass, ' ', $targetDisplay, ' ', $collapsibleWordBoxClass))}">
			<xsl:if test="$useCollapsibleWordPools='y'">
				<xsl:call-template name="outputCollapsibleToggleButton"/>
				<xsl:call-template name="outputCollapsiblePreviousItemButton"/>
			</xsl:if>

			<ul>
				<xsl:for-each select="$categorise//item">
					<xsl:sort select="@rank" data-type="number" order="ascending"/>
					<xsl:variable name="actID"><xsl:value-of select="ancestor::activity/@id"/></xsl:variable>
					<xsl:variable name="isDistractor"><xsl:if test="count(ancestor::distractors)>0">Y</xsl:if></xsl:variable>
					<xsl:variable name="genID">
						<xsl:choose>
							<xsl:when test="$isDistractor!='Y'">C<xsl:value-of select="count(ancestor::category/preceding-sibling::*)+1"/>_I<xsl:value-of select="position()"/>_A<xsl:value-of select="$actID"/></xsl:when>
							<xsl:otherwise>D_<xsl:value-of select="position()"/>_<xsl:value-of select="$actID"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="categoryItemID">catItem_<xsl:value-of select="$genID"/></xsl:variable>
					<xsl:variable name="catItemID"><xsl:value-of select="@id"/></xsl:variable>
					<xsl:variable name="useCount"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$catItemID and not(@example='y')])"/></xsl:variable>
					<xsl:variable name="numberOfExamplesWithThisId"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$catItemID and @example='y'])"/></xsl:variable>
					<xsl:variable name="numberOfUsesOfThisId"><xsl:value-of select="count(ancestor::complexCategorise/categories/category/item[@id=$catItemID])"/></xsl:variable>

					<xsl:variable name="isExampleAndUnusedElsewhere">
						<xsl:choose>
							<xsl:when test="$numberOfExamplesWithThisId>0 and $numberOfExamplesWithThisId = $numberOfUsesOfThisId">y</xsl:when>
							<xsl:otherwise>n</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="restrictCount">
						<xsl:choose>
							<xsl:when test="$isExampleAndUnusedElsewhere='y'">0</xsl:when>
							<xsl:when test="$useCount=0">1</xsl:when>
							<xsl:otherwise><xsl:value-of select="$useCount"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="categoryName">
						<xsl:choose>
							<xsl:when test="count(ancestor::complexCategorise)>0">
								<xsl:for-each select="ancestor::complexCategorise/categories/category[count(item[@id=$catItemID])>0]">category_<xsl:value-of select="$actID"/>_cat<xsl:value-of select="count(preceding-sibling::*)+1"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each>
							</xsl:when>
							<xsl:when test="$isDistractor='Y'"></xsl:when>
							<xsl:otherwise>category_<xsl:value-of select="$actID"/>_cat<xsl:value-of select="count(ancestor::category/preceding-sibling::*)+1"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:if test="(not(@example='y') and ($isExampleAndUnusedElsewhere!='y')) or ((ancestor::complexCategorise) and not(ancestor::complexCategorise/@restrict='y'))">
						<li id="{$categorise/@id}_{$targetDisplay}_{$genID}" data-rcfid="{@id}">
							<xsl:variable name="categoriseItemClass">
								dragItem
								dev-droppable
								dev-markable-container
								clickAndStickable
								ui-draggable
								<xsl:if test="count(image)>0 or count(imageAudio)>0">
									dragImageItem
								</xsl:if>
								<xsl:call-template name="itemContentStylingClasses">
									<xsl:with-param name="itemElement" select="." />
								</xsl:call-template>
								<xsl:if test="$isDistractor='Y'">
									distractor
								</xsl:if>
								<xsl:if test="ancestor::complexCategorise">
									complex
								</xsl:if>
							</xsl:variable>
							<xsl:attribute name="class"><xsl:value-of select="normalize-space($categoriseItemClass)"/></xsl:attribute>
							<xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute></xsl:if>
							<xsl:if test="@correctFeedbackAudio"><xsl:attribute name="data-correctfeedbackaudio"><xsl:value-of select="@correctFeedbackAudio"/></xsl:attribute></xsl:if>
							<xsl:if test="count(@rank)>0"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
							<xsl:if test="ancestor::complexCategorise/@restrict='y'"><xsl:attribute name="data-restrictcount"><xsl:value-of select="$restrictCount"/></xsl:attribute></xsl:if>
							<span class="markable dragItem">
								<xsl:apply-templates/>
								<span class="mark">&#160;&#160;&#160;&#160;</span>
							</span>
						</li>
					</xsl:if>
				</xsl:for-each>
			</ul>

			<xsl:if test="$useCollapsibleWordPools='y'">
				<xsl:call-template name="outputCollapsibleNextItemButton"/>
			</xsl:if>
		</div>
	</xsl:template>
</xsl:stylesheet>
