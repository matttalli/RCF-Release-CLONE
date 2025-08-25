<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes"/>

	<xsl:template match="wordInsert">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or (count(items/item[@positionable='y']) = 0)">example</xsl:if></xsl:variable>


		<div data-rcfinteraction="wordInsert" data-rcfid="{@id}" class="{normalize-space(concat('sentenceBuilderContainer wordInsertContainer', ' ', $exampleClass, ' ', @class, ' ', 'dev-markable-container'))}">
			<xsl:if test="$wordBoxPosition='default' or $wordBoxPosition='top'">
				<xsl:apply-templates select="." mode="outputWordInsertBuilderWordBox"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="outputWordInsertSentenceArea"/>
			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:apply-templates select="." mode="outputWordInsertBuilderWordBox"/>
			</xsl:if>
		</div>

	</xsl:template>

	<xsl:template match="wordInsert" mode="outputWordInsertBuilderWordBox">
		<xsl:variable name="wordInsertClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('wordInsertWordBox ', $wordInsertClasses))}">
			<ul>
				<xsl:apply-templates select="items/item[@positionable='y']" mode="outputWordInsertBuilderWordBoxItems"/>
				<xsl:apply-templates select="distractors/item" mode="outputWordInsertBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="wordInsert[@example='y' or (count(items/item[@positionable='y'])=0 and count(distractors/item) = 0) ]" mode="outputWordInsertBuilderWordBox">
		<xsl:variable name="wordInsertClasses">
			<xsl:call-template name="sentenceBuilderWordBoxClasses" >
				<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('wordInsertWordBox ', $wordInsertClasses))}">
			<ul>
				<xsl:apply-templates select="distractors/item" mode="outputWordInsertBuilderWordBoxItems"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="wordInsert" mode="outputWordInsertSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<xsl:variable name="numberOfFixedItems"><xsl:value-of select="count(items/prefix) + count(items/item[not(@positionable='y')]) + count(items/suffix)"/></xsl:variable>

		<div class="wordInsertSentenceBuilder sentenceBuilder">
			<ul class="{normalize-space(concat('wordInsertSentenceWordList sentenceWordList ', $capitaliseClass))}">
				<xsl:choose>
					<xsl:when test="$numberOfFixedItems = 0">
						<xsl:text>&#160;</xsl:text>
						<li class="dev-placeholder"></li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="items/*" mode="outputWordInsertFixedItems"/>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>

	</xsl:template>

	<xsl:template match="wordInsert[@example='y']" mode="outputWordInsertSentenceArea">
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>

		<div class="wordInsertSentenceBuilder sentenceBuilder">
			<ul class="{normalize-space(concat('wordInsertSentenceWordList sentenceWordList ', $capitaliseClass))}">
				<xsl:apply-templates select="items/prefix" mode="outputWordInsertFixedItems"/>
				<xsl:apply-templates select="items/item" mode="outputWordInsertBuilderWordBoxItems"/>
				<xsl:apply-templates select="items/suffix" mode="outputWordInsertFixedItems"/>
			</ul>
			<span class="mark">&#160;&#160;&#160;&#160;</span>
		</div>
	</xsl:template>


	<xsl:template match="wordInsert/items/prefix" mode="outputWordInsertFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('prefix fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="1">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="wordInsert/items/suffix" mode="outputWordInsertFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li class="{normalize-space(concat('suffix fixed dragItem ', @class))}" data-fixed="y" data-rank="999" data-fixedpos="{count(ancestor::items/item) + count(ancestor::items/prefix) + 1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="wordInsert/items/item[not(@positionable='y')]" mode="outputWordInsertFixedItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<li data-rcfid="{@id}" class="{normalize-space(concat('fixed dragItem ', @class))}" data-fixed="y" data-fixedpos="{count(preceding-sibling::item) + count(ancestor::items/prefix) +1}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="item" mode="outputWordInsertBuilderWordBoxItems">
		<xsl:variable name="originalTextValue"><xsl:apply-templates/></xsl:variable>
		<xsl:variable name="draggedClass"><xsl:if test="ancestor::wordInsert/@example='y' and not(ancestor::distractors)">dragged</xsl:if></xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="ancestor::wordInsert/@example='y' and not(@positionable='y')">fixed</xsl:if></xsl:variable>

		<li data-rcfid="{@id}" class="{normalize-space(concat('dragItem dev-droppable ', @class, ' ', $draggedClass, ' ', $exampleClass))}">
			<xsl:attribute name="data-originalValue"><xsl:value-of select="$originalTextValue"/></xsl:attribute>
			<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="text()" mode="outputWordInsertFixedItems"/>

	<!-- rcf_word_insert -->
	<xsl:template match="wordInsert" mode="getRcfClassName">
		rcfWordInsert
	</xsl:template>

</xsl:stylesheet>
