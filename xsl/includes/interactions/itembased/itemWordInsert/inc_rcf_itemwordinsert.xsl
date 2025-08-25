<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes"/>

	<xsl:template match="itemWordInsert">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or (count(items/item[@positionable='y']) = 0)">example</xsl:if></xsl:variable>

		<div data-rcfinteraction="itemWordInsert" data-rcfid="{@id}" class="{normalize-space(concat('sentenceBuilderContainer itemWordInsertContainer', ' ', $exampleClass, ' ', @class, ' ', 'dev-markable-container'))}">
			<xsl:if test="$wordBoxPosition='default' or $wordBoxPosition='top'">
				<xsl:apply-templates select="." mode="outputItemWordInsertBuilderWordBox"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="outputItemWordInsertSentenceArea"/>
			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:apply-templates select="." mode="outputItemWordInsertBuilderWordBox"/>
			</xsl:if>
		</div>

	</xsl:template>

	<xsl:template match="itemWordInsert" mode="outputItemWordInsertBuilderWordBox">
		<xsl:variable name="itemWordInsertClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('itemWordInsertWordBox ', $itemWordInsertClasses))}">
			<ul>
				<xsl:apply-templates select="items/item[@positionable='y']" mode="outputItemWordInsertBuilderWordBoxItems"/>
				<xsl:apply-templates select="distractors/item" mode="outputItemWordInsertBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="itemWordInsert[@example='y' or (count(items/item[@positionable='y']) = 0 and count(distractors/item) = 0)]" mode="outputItemWordInsertBuilderWordBox">
		<xsl:variable name="itemWordInsertClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('itemWordInsertWordBox ', $itemWordInsertClasses))}">
			<ul>
				<xsl:apply-templates select="distractors/item" mode="outputItemWordInsertBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="itemWordInsert" mode="outputItemWordInsertSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<xsl:variable name="numberOfFixedItems"><xsl:value-of select="count(items/prefix) + count(items/item[not(@positionable='y')]) + count(items/suffix)"/></xsl:variable>

		<div class="itemWordInsertSentenceBuilder sentenceBuilder">
			<ul class="{normalize-space(concat('itemWordInsertSentenceWordList sentenceWordList ', $capitaliseClass))}">
				<xsl:choose>
					<xsl:when test="$numberOfFixedItems = 0">
						<xsl:text>&#160;</xsl:text>
						<li class="dev-placeholder"></li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="items/*" mode="outputItemWordInsertFixedItems"/>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>

	</xsl:template>

	<xsl:template match="itemWordInsert[@example='y']" mode="outputItemWordInsertSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<div class="itemWordInsertSentenceBuilder sentenceBuilder">
			<ul class="{normalize-space(concat('itemWordInsertSentenceWordList sentenceWordList ', $capitaliseClass))}">
				<xsl:apply-templates select="items/prefix" mode="outputItemWordInsertFixedItems"/>
				<xsl:apply-templates select="items/item" mode="outputItemWordInsertBuilderWordBoxItems"/>
				<xsl:apply-templates select="items/suffix" mode="outputItemWordInsertFixedItems"/>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>
	</xsl:template>


	<xsl:template match="itemWordInsert/items/prefix" mode="outputItemWordInsertFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('prefix fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="1">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="itemWordInsert/items/suffix" mode="outputItemWordInsertFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('suffix fixed dragItem ', @class))}" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::items/item) + count(ancestor::items/prefix) + 1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="itemWordInsert/items/item[not(@positionable='y')]" mode="outputItemWordInsertFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li data-rcfid="{@id}" class="{normalize-space(concat('fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="{count(preceding-sibling::item) + count(ancestor::items/prefix) +1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="item" mode="outputItemWordInsertBuilderWordBoxItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<xsl:variable name="draggedClass"><xsl:if test="ancestor::itemWordInsert/@example='y' and not(ancestor::distractors)">dragged</xsl:if></xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="ancestor::itemWordInsert/@example='y' and not(@positionable='y')">fixed</xsl:if></xsl:variable>

		<li data-rcfid="{@id}" class="{normalize-space(concat('dragItem dev-droppable ', @class, ' ', $draggedClass, ' ', $exampleClass))}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="text()" mode="outputItemWordInsertFixedItems"/>

	<!-- rcf_itembased_wordinsert -->
	<xsl:template match="itemWordInsert" mode="getItemBasedRcfClassName">
		rcfItemBasedWordInsert
	</xsl:template>

</xsl:stylesheet>
