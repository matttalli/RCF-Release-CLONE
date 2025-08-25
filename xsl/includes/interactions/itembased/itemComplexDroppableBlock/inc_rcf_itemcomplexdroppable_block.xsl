<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="itemComplexDroppableBlock">
		<div class="itemComplexDroppableBlock {@class}" data-rcfid="{@id}" data-rcfinteraction="itemComplexDroppableBlock">
			<xsl:if test="@restrict='y'">
				<xsl:attribute name="data-restrict">y</xsl:attribute>
			</xsl:if>
			<!-- output wordbox -->
			<xsl:if test="$wordBoxPosition='top' or $wordBoxPosition='default'">
				<xsl:apply-templates select="." mode="outputWordBox"/>
			</xsl:if>
			<!-- output contents -->
			<xsl:apply-templates select="." mode="outputContents"/>
			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:apply-templates select="." mode="outputWordBox"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="itemComplexDroppableBlock" mode="outputWordBox">
		<xsl:variable name="fixedWordBoxClass"><xsl:if test="$useFixedWordPools='y'">fixedWordBox</xsl:if></xsl:variable>
		<div class="{normalize-space(concat('wordBox', ' ', 'itemComplexDroppableBlockWordBox', ' ', 'complex', ' ', $fixedWordBoxClass))}">
			<xsl:if test="@restrict='y'">
				<xsl:attribute name="data-restrictcount">1</xsl:attribute>
			</xsl:if>
			<ul>
				<xsl:apply-templates select="itemComplexDroppables/item" mode="outputWordBox"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="itemComplexDroppableBlock" mode="outputContents">
		<div class="itemComplexDroppableBlockContents block">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="itemComplexDroppables"/>

	<xsl:template match="itemComplexDroppables/item" mode="outputWordBox">
		<xsl:variable name="restrictedComplexDroppables" select="ancestor::itemComplexDroppableBlock/@restrict"/>
		<xsl:variable name="complexDroppableId"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="correctItemCount"><xsl:value-of select="count(ancestor::itemComplexDroppableBlock//itemComplexDroppable[not(@example='y')]/item[@id=$complexDroppableId])"/></xsl:variable>
		<xsl:variable name="usedAsAnExample"><xsl:if test="count(ancestor::itemComplexDroppableBlock//itemComplexDroppable[@example='y']/item[@id=$complexDroppableId])>0">y</xsl:if></xsl:variable>
		<xsl:variable name="imageAnswerClass">
			<!-- <xsl:if test="count(.//image) + count(.//imageAudio) &gt; 0">imageAnswer</xsl:if> -->
			<xsl:call-template name="itemContentStylingClasses">
				<xsl:with-param name="itemElement" select="." />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="imageClass"><xsl:if test="count(.//image) + count(.//imageAudio) &gt; 0">dragImageItem</xsl:if></xsl:variable>

		<!-- distractors are deduced by their use-count -->
		<xsl:variable name="distractorClass"><xsl:if test="$correctItemCount=0">distractor</xsl:if></xsl:variable>

		<xsl:if test="not($correctItemCount=0 and $usedAsAnExample='y' and $restrictedComplexDroppables='y')">
			<li data-complexid="complex_{@id}"
				data-rcfid="{@id}"
				class="{normalize-space(concat('dragItem dev-droppable complex clickAndStickable ', $imageClass, ' ', $distractorClass, ' ', $imageAnswerClass))}"
				data-rcfTranslate=""
				aria-roledescription="[ interactions.droppable.dragItem.ariaRoleDescription ]"
				tabindex="0"
			>
				<xsl:if test="$restrictedComplexDroppables='y'">
					<xsl:attribute name="data-restrictcount">
						<xsl:choose>
							<xsl:when test="not(@restrictMaxShown)">
								<xsl:choose>
									<xsl:when test="$correctItemCount=0">1</xsl:when>
									<xsl:otherwise><xsl:value-of select="$correctItemCount"/></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@restrictMaxShown"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute></xsl:if>
				<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
				<xsl:apply-templates/>
			</li>
		</xsl:if>

	</xsl:template>

	<xsl:template match="itemComplexDroppable">
		<xsl:variable name="imageAnswerClass">
			<xsl:variable name="itemId"><xsl:value-of select="item[1]/@id"/></xsl:variable>
			<xsl:variable name="droppable" select="ancestor::itemComplexDroppableBlock/itemComplexDroppables/item[@id=$itemId]"/>
			<xsl:call-template name="itemContentStylingClasses">
				<xsl:with-param name="itemElement" select="$droppable" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="populatedClass"><xsl:if test="@example='y'">populated</xsl:if></xsl:variable>
		<xsl:variable name="capitaliseClass"><xsl:if test="@capitalise='y'">capitalise</xsl:if></xsl:variable>
		<xsl:variable name="firstCorrectID"><xsl:value-of select="item[1]/@id"/></xsl:variable>
		<xsl:variable name="containsImages">
			<xsl:for-each select="item">
				<xsl:variable name="itemId"><xsl:value-of select="@id"/></xsl:variable>
				<xsl:if test="count(ancestor::itemComplexDroppableBlock/itemComplexDroppables/item[@id=$itemId]//image) + count(ancestor::itemComplexDroppableBlock/itemComplexDroppables/item[@id=$itemId]//imageAudio) &gt; 0">y</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="imagesClass"><xsl:if test="contains($containsImages, 'y')">complexDroppableImage</xsl:if></xsl:variable>
		<xsl:variable name="dropTargetImagesClass"><xsl:if test="contains($containsImages, 'y')">complexDragImageTarget</xsl:if></xsl:variable>

		<span data-rcfid="{@id}"
			class="{normalize-space(concat('itemComplexDroppable clickAndStickable rcfDroppable ', $exampleClass, ' ', $imagesClass, ' ' , $imageAnswerClass))}"
		>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:variable name="acceptable">
				<xsl:for-each select="item">complex_<xsl:value-of select="@id"/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each>
			</xsl:variable>

			<xsl:if test="prefix">
				<span class="prefix"><xsl:value-of select="prefix"/></span>
			</xsl:if>

			<xsl:variable name="titleText">
				<xsl:choose>
					<xsl:when test="@example='y'">[ interactions.droppable.exampleDropTarget.title ]</xsl:when>
					<xsl:otherwise>[ interactions.droppable.dropTarget.title ] <xsl:value-of select="count(preceding::complexDroppable[not(@example)]) + 1" />, [ interactions.droppable.dropTarget.empty ]</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<span class="markable dev-markable-container">
				<span
					class="{normalize-space(concat('dev-droppable dragTarget movable ', $populatedClass, ' ', $exampleClass, ' ', $capitaliseClass, ' ', $dropTargetImagesClass))}"
					data-rcfTranslate="" title="{$titleText}" role="region">
					<xsl:if test="@example='y'">
						<xsl:if test="ancestor::itemComplexDroppableBlock/itemComplexDroppables/item[@id=$firstCorrectID]/@audio">
							<xsl:attribute name="data-audiolink">
								<xsl:value-of
									select="ancestor::itemComplexDroppableBlock/itemComplexDroppables/item[@id=$firstCorrectID]/@audio" />
							</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not(@example='y')">
						<xsl:attribute name="tabindex">0</xsl:attribute>
					</xsl:if>
					<xsl:if test="@capitalise='y'"><xsl:attribute name="data-capitalise">y</xsl:attribute></xsl:if>
					<xsl:if test="@example='y'"><xsl:apply-templates select="ancestor::itemComplexDroppableBlock/itemComplexDroppables/item[@id=$firstCorrectID]"/></xsl:if>
				</span>
				<span class="mark" aria-hidden="true">&#160;&#160;&#160;&#160;</span>
			</span>
			<xsl:if test="suffix">
				<span class="suffix"><xsl:value-of select="suffix"/></span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="itemComplexDroppableBlock/itemComplexDroppables/item//audio">
		<xsl:variable name="audioLinkId"><xsl:value-of select="ancestor::item[parent::itemList]/@id"/>_<xsl:value-of select="ancestor::itemComplexDroppableBlock/@id"/>_<xsl:value-of select="count(preceding::audio)"/></xsl:variable>

		<span data-insideComplexDroppable="y"
				class="inlinePlayerContainer"
				data-audiolink="{track/@src}"
				data-audiolinkid="audio-{$audioLinkId}"
		>
			<span class="inlinePlayer">
				<button class="audioPlayButton" tabindex="0" type="button">
					<xsl:call-template name="audioPlayIcon"/>
					<xsl:call-template name="audioStopIcon"/>
					<span class="audioPlayButtonPlayLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.play ]</span>
					<span class="audioPlayButtonStopLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.stop ]</span>
				</button>
			</span>
		</span>
	</xsl:template>

	<!-- rcf_itembased_complexdroppable_block -->
	<xsl:template match="itemComplexDroppableBlock" mode="getItemBasedRcfClassName">
		rcfItemBasedComplexDroppableBlock
	</xsl:template>

</xsl:stylesheet>
