<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes"/>

	<xsl:template match="sentenceBuilder">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or (count(items/item[@fixed='y'])=count(items/item))">example</xsl:if></xsl:variable>
		<xsl:variable name="sentenceBuilderClass">sentenceBuilderContainer<xsl:if test="@example='y'"><xsl:text> </xsl:text>example</xsl:if><xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if></xsl:variable>

		<div data-rcfinteraction="sentenceBuilder" data-rcfid="{@id}" class="{normalize-space(concat('sentenceBuilderContainer ', $exampleClass, ' ', @class, ' ', 'dev-markable-container'))}">
			<xsl:if test="$wordBoxPosition='default' or $wordBoxPosition='top'">
				<xsl:apply-templates select="." mode="outputSentenceBuilderWordBox"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="outputSentenceBuilderSentenceArea"/>

			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:apply-templates select="." mode="outputSentenceBuilderWordBox"/>
			</xsl:if>
		</div>

	</xsl:template>

	<xsl:template match="sentenceBuilder" mode="outputSentenceBuilderWordBox">
		<xsl:variable name="sentenceBuilderWordBoxClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{$sentenceBuilderWordBoxClasses}">
			<ul>
				<xsl:apply-templates select="items/item[not(@fixed='y')]" mode="outputSentenceBuilderWordBoxItems"/>
				<xsl:apply-templates select="distractors/item" mode="outputSentenceBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="sentenceBuilder[@example='y' or (count(items/item[@fixed='y']) = count(items/item))]" mode="outputSentenceBuilderWordBox">
		<xsl:variable name="sentenceBuilderWordBoxClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{$sentenceBuilderWordBoxClasses}">
			<ul>
				<xsl:apply-templates select="distractors/item" mode="outputSentenceBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="sentenceBuilder" mode="outputSentenceBuilderSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<xsl:variable name="numberOfFixedItems"><xsl:value-of select="count(items/prefix) + count(items/item[@fixed='y']) + count(items/suffix)"/></xsl:variable>

		<div class="sentenceBuilder">
			<ul class="{normalize-space(concat('sentenceWordList ', $capitaliseClass))}">
				<xsl:choose>
					<xsl:when test="$numberOfFixedItems = 0">
						<xsl:text>&#160;</xsl:text>
						<li class="dev-placeholder"></li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="items/*" mode="outputSentenceBuilderFixedItems"/>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>

	</xsl:template>

	<xsl:template match="sentenceBuilder[@example='y']" mode="outputSentenceBuilderSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>

		<div class="sentenceBuilder">
			<ul class="{normalize-space(concat('sentenceWordList ', $capitaliseClass))}">
				<xsl:apply-templates select="items/prefix" mode="outputSentenceBuilderFixedItems"/>
				<xsl:apply-templates select="items/item" mode="outputSentenceBuilderWordBoxItems"/>
				<xsl:apply-templates select="items/suffix" mode="outputSentenceBuilderFixedItems"/>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>
	</xsl:template>


	<xsl:template match="sentenceBuilder/items/prefix" mode="outputSentenceBuilderFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('prefix fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="1">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="sentenceBuilder/items/suffix" mode="outputSentenceBuilderFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('suffix fixed dragItem ', @class))}" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::items/item) + count(ancestor::items/prefix) + 1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="sentenceBuilder/items/item[@fixed='y']" mode="outputSentenceBuilderFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li data-rcfid="{@id}" class="{normalize-space(concat('fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="{count(preceding-sibling::item) + count(ancestor::items/prefix) +1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="item" mode="outputSentenceBuilderWordBoxItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<xsl:variable name="draggedClass"><xsl:if test="ancestor::sentenceBuilder/@example='y' and not(ancestor::distractors)">dragged</xsl:if></xsl:variable>

		<li data-rcfid="{@id}" class="{normalize-space(concat('dragItem dev-droppable ', @class, ' ', $draggedClass))}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="text()" mode="outputSentenceBuilderFixedItems"/>

	<!-- rcf_sentence_builder -->
	<xsl:template match="sentenceBuilder" mode="getRcfClassName">
		rcfSentenceBuilder
	</xsl:template>

</xsl:stylesheet>
