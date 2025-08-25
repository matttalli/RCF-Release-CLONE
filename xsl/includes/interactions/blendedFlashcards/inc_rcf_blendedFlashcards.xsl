<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="blendedFlashcards">
		<xsl:variable name="defaultLayoutClassName">layoutSingle</xsl:variable>
		<xsl:variable name="hasTextCardsClass"><xsl:if test="count(textCard)>0">hasTextCards</xsl:if></xsl:variable>
		<xsl:variable name="nextCardClass">cardNavigation nextCard<xsl:if test="count(card | textCard)>1"> active</xsl:if></xsl:variable>
		<xsl:variable name="numberOfCards" select="count(./card) + count(./textCard)"/>
		<div class="blendedFlashcards cards{$numberOfCards} {$defaultLayoutClassName} {$hasTextCardsClass}" data-rcfinteraction="blendedFlashcards" data-ignoreNextAnswer="y">

			<xsl:call-template name="outputBlendedFlashcardControls"/>

			<div class="block blendedFlashcardStage">
				<ul class="cardSet" role="carousel" aria-label="Flashcards">
					<xsl:apply-templates/>
				</ul>
			</div>

			<div class="block blendedFlashcardSelection">
				<div class="cardNavigation previousCard" data-nav-mode="previousCard">
					<button class="card-navigation__prev" type="button" data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.pagination.previousFlashcard ]"></button>
				</div>
				<xsl:apply-templates select="." mode="blendedFlashcardsNavigation"/>
				<div class="{$nextCardClass}" data-nav-mode="nextCard">
					<button class="ard-navigation__next" type="button" data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.pagination.nextFlashcard ]"></button>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="blendedFlashcards/card">
		<xsl:variable name="originalOrder"><xsl:value-of select="count(preceding-sibling::*)+1"/></xsl:variable>
		<xsl:variable name="numberOfCards" select="count(../card) + count(../textCard)"/>
		<xsl:variable name="imageUrl">
			<xsl:call-template name="getImageSource">
				<xsl:with-param name="sourceValue" select="@image"/>
			</xsl:call-template>
		</xsl:variable>

		<li role="group" aria-roledescription="slide" data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.flashcardOf.flashcard ] {$originalOrder} [ interactions.blendedFlashcards.flashcardOf.of ] {$numberOfCards}" data-originalorder="{$originalOrder}" data-rank="{$originalOrder}" tabindex="0">
			<xsl:if test="count(preceding-sibling::*)=0"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
			<div class="block card hideTop hideBottom" data-rcfid="{@id}">
				<xsl:if test="@image">
					<div class="imageContainer topContainer"
						 role="button"
						 tabindex="0"
						 aria-expanded="false"
						 aria-controls="img-content-{@id}"
						 data-rcfTranslate=""
						 aria-label="[ interactions.blendedFlashcards.image.hidden ]">
						<img src="{$imageUrl}" id="img-content-{@id}" aria-hidden="true">
							<xsl:attribute name="alt">
                				<xsl:value-of select="@a11yTitle"/>
            				</xsl:attribute>

							<xsl:if test="@a11yTitleLang">
								<xsl:attribute name="lang">
									<xsl:value-of select="@a11yTitleLang"/>
								</xsl:attribute>
							</xsl:if>
						</img>
					</div>
				</xsl:if>

				<p class="word">
					<xsl:if test="@audio">
						<span data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.audio.clickToPlay ]">
							<xsl:call-template name="createInlineAudioPlayer">
								<xsl:with-param name="audio" select="@audio"/>
								<xsl:with-param name="audioId">blendedFlashCard_<xsl:value-of select="@id"/></xsl:with-param>
							</xsl:call-template>
						</span>
					</xsl:if>
					<span class="textContainer"
							role="button"
							tabindex="0"
							aria-expanded="false"
							aria-controls="text-content-{@id}"
							data-rcfTranslate=""
						 	aria-label="[ interactions.blendedFlashcards.text.hidden ]">
						<span class="text" id="text-content-{@id}" aria-hidden="true">
							<xsl:apply-templates/>
						</span>
					</span>
				</p>
			</div>
		</li>
	</xsl:template>

	<xsl:template match="blendedFlashcards/textCard">
		<xsl:variable name="originalOrder"><xsl:value-of select="count(preceding-sibling::*)+1"/></xsl:variable>
		<xsl:variable name="numberOfCards" select="count(../card) + count(../textCard)"/>
		<li role="group" aria-roledescription="slide" data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.flashcardOf.flashcard ] {$originalOrder} [ interactions.blendedFlashcards.flashcardOf.of ] {$numberOfCards}" data-originalorder="{$originalOrder}" data-rank="{$originalOrder}" tabindex="0">
			<xsl:if test="count(preceding-sibling::*)=0"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
			<div class="block card textCard hideTop hideBottom" data-rcfid="{@id}">
				<div class="definition topContainer" tabindex="0">
					<p>
						<xsl:apply-templates select="definition" />
					</p>
				</div>
				<p class="word">
					<xsl:if test="@audio">
						<xsl:call-template name="createInlineAudioPlayer">
							<xsl:with-param name="audio" select="@audio"/>
							<xsl:with-param name="audioId">blendedFlashCard_textCard_<xsl:value-of select="@id"/></xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<span class="textContainer"
							role="button"
							tabindex="0"
							aria-expanded="false"
							aria-controls="text-content-{@id}"
							aria-label="Text, click to reveal">
						<span class="text" id="text-content-{@id}" aria-hidden="true">
							<xsl:apply-templates/>
						</span>
					</span>
				</p>
			</div>
		</li>
	</xsl:template>

	<xsl:template match="blendedFlashcards" mode="blendedFlashcardsNavigation">
		<ul class="cardList">
			<xsl:variable name="total" select="count(*)"/>
			<xsl:for-each select="*">
				<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="thumbnailClass">cardNavigation<xsl:if test="$pos=1"> active</xsl:if></xsl:variable>
				<xsl:variable name="textCardClass"><xsl:if test="name()='textCard'">cardText</xsl:if></xsl:variable>
				<xsl:variable name="imageUrl">
					<xsl:call-template name="getImageSource">
						<xsl:with-param name="sourceValue" select="@image"/>
					</xsl:call-template>
				</xsl:variable>

				<li class="{$thumbnailClass} {$textCardClass}" data-originalorder="{$pos}" data-rank="{$pos}" data-nav-mode="thumbnailClick" data-rcfid="{@id}">
					<button class="card-list__page-indicator" type="button" data-rcfTranslate="">
						<xsl:attribute name="aria-label">
							[ interactions.blendedFlashcards.flashcardOf.flashcard ] <xsl:value-of select="$pos"/> [ interactions.blendedFlashcards.flashcardOf.of ] <xsl:value-of select="$total"/><xsl:choose><xsl:when test="$pos = 1"> [ interactions.blendedFlashcards.pagination.selected ]</xsl:when><xsl:otherwise>, [ interactions.blendedFlashcards.pagination.clickToSelect ]</xsl:otherwise></xsl:choose>
						</xsl:attribute>
						<xsl:if test="@image">
							<div class="imageContainer">
								<img src="{$imageUrl}"/>
							</div>
						</xsl:if>
					</button>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template name="outputBlendedFlashcardControls">
		<div class="block blendedFlashcardControls">
			<xsl:call-template name="outputBlendedFlashcardSequenceControls"/>
			<xsl:call-template name="outputBlendedFlashcardViewControls"/>
		</div>
	</xsl:template>
	<xsl:template name="outputBlendedFlashcardSequenceControls">
		<ul class="sequenceControl">
			<li class="button blendedFlashcardShuffle" data-mode="shuffle">
				<button data-rcfTranslate="">[ interactions.blendedFlashcards.shuffle.caption ]</button>
			</li>
		</ul>
	</xsl:template>

	<xsl:template name="outputBlendedFlashcardViewControls">
		<div class="block viewControlsContainer">
			<ul class="blendedFlashcardLayouts">
				<li class="button viewFull active" data-mode="full">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.full.caption ]">[ interactions.blendedFlashcards.full.caption ]</button>
				</li>
				<li class="button viewSingle" data-mode="single">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.single.caption ]">[ interactions.blendedFlashcards.single.caption ]</button>
				</li>
				<li class="button viewGrid" data-mode="grid">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.grid.caption ]">[ interactions.blendedFlashcards.grid.caption ]</button>
				</li>
			</ul>
			<ul class="blendedFlashcardModes">
				<li class="button hideAll active" data-mode="hide-all">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.hideAll.caption ]">[ interactions.blendedFlashcards.hideAll.caption ]</button>
				</li>
				<li class="button showTop" data-mode="image">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.image.caption ]">[ interactions.blendedFlashcards.image.caption ]</button>
				</li>
				<li class="button showBottom" data-mode="text">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.text.caption ]">[ interactions.blendedFlashcards.text.caption ]</button>
				</li>
				<li class="button showAll" data-mode="show-all">
					<button data-rcfTranslate="" aria-label="[ interactions.blendedFlashcards.showAll.caption ]">[ interactions.blendedFlashcards.showAll.caption ]</button>
				</li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="blendedFlashcards" mode="getUnmarkedInteractionName">
		rcfBlendedFlashcards
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>
</xsl:stylesheet>
