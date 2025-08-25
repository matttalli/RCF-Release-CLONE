<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes"/>

	<xsl:template match="itemSentenceBuilder">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or (count(items/item[@fixed='y'])=count(items/item))">example</xsl:if></xsl:variable>

		<div data-rcfinteraction="itemSentenceBuilder" data-rcfid="{@id}" class="{normalize-space(concat('sentenceBuilderContainer itemSentenceBuilderContainer', ' ', $exampleClass, ' ', @class, ' ', 'dev-markable-container'))}">

			<xsl:if test="$wordBoxPosition='default' or $wordBoxPosition='top'">
				<xsl:apply-templates select="." mode="outputItemSentenceBuilderWordBox"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="outputItemSentenceBuilderSentenceArea"/>

			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:apply-templates select="." mode="outputItemSentenceBuilderWordBox"/>
			</xsl:if>

		</div>

	</xsl:template>

	<xsl:template match="itemSentenceBuilder" mode="outputItemSentenceBuilderWordBox">
		<xsl:variable name="itemSentenceBuilderWordBoxClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('itemSentenceBuilderWordBox ', $itemSentenceBuilderWordBoxClasses))}">
			<ul>
				<xsl:apply-templates select="items/item[not(@fixed='y')]" mode="outputItemSentenceBuilderWordBoxItems"/>
				<xsl:apply-templates select="distractors/item" mode="outputItemSentenceBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="itemSentenceBuilder[@example='y' or (count(items/item[@fixed='y']) = count(items/item))]" mode="outputItemSentenceBuilderWordBox">
		<xsl:variable name="itemSentenceBuilderWordBoxClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('itemSentenceBuilderWordBox ', $itemSentenceBuilderWordBoxClasses))}">
			<ul>
				<xsl:apply-templates select="distractors/item" mode="outputItemSentenceBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="itemSentenceBuilder" mode="outputItemSentenceBuilderSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<xsl:variable name="numberOfFixedItems"><xsl:value-of select="count(items/prefix) + count(items/item[@fixed='y']) + count(items/suffix)"/></xsl:variable>

		<div class="itemSentenceBuilder sentenceBuilder">
			<ul class="{normalize-space(concat('itemSentenceWordList sentenceWordList ', $capitaliseClass))}">
				<xsl:choose>
					<xsl:when test="$numberOfFixedItems = 0">
						<xsl:text>&#160;</xsl:text>
						<li class="dev-placeholder"></li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="items/*" mode="outputItemSentenceBuilderFixedItems"/>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>

	</xsl:template>

	<xsl:template match="itemSentenceBuilder[@example='y']" mode="outputItemSentenceBuilderSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<div class="itemSentenceBuilder sentenceBuilder">
			<ul class="{normalize-space(concat('itemSentenceWordList sentenceWordList ', $capitaliseClass))}">
				<xsl:apply-templates select="items/prefix" mode="outputItemSentenceBuilderFixedItems"/>
				<xsl:apply-templates select="items/item" mode="outputItemSentenceBuilderWordBoxItems"/>
				<xsl:apply-templates select="items/suffix" mode="outputItemSentenceBuilderFixedItems"/>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>
	</xsl:template>


	<xsl:template match="itemSentenceBuilder/items/prefix" mode="outputItemSentenceBuilderFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('prefix fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="1">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="itemSentenceBuilder/items/suffix" mode="outputItemSentenceBuilderFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('suffix fixed dragItem ', @class))}" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::items/item) + count(ancestor::items/prefix) + 1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="itemSentenceBuilder/items/item[@fixed='y']" mode="outputItemSentenceBuilderFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li data-rcfid="{@id}" class="{normalize-space(concat('fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="{count(preceding-sibling::item) + count(ancestor::items/prefix) +1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="item" mode="outputItemSentenceBuilderWordBoxItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<xsl:variable name="draggedClass"><xsl:if test="ancestor::itemSentenceBuilder/@example='y' and not(ancestor::distractors)">dragged</xsl:if></xsl:variable>

		<li data-rcfid="{@id}" class="{normalize-space(concat('dragItem dev-droppable ', @class, ' ', $draggedClass))}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="text()" mode="outputItemSentenceBuilderFixedItems"/>

	<!-- rcf_itembased_sentencebuilder -->
	<xsl:template match="itemSentenceBuilder" mode="getItemBasedRcfClassName">
		rcfItemBasedSentenceBuilder
	</xsl:template>

</xsl:stylesheet>
