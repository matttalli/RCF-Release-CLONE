<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		output the matching container

		<div matchingContainer....

			<div class='matching'>
				... for each 'pair'....
				<div class="matchItemContainer">
					<div class="matchItem"> .. </div>
				</div>

				<div class="matchTargetContainer">
					<div class="matchTarget"> .. </div>
				</div>

			</div>

		</div>
	-->

	<xsl:template match="matching">
		<!-- determine the kind of matching interactions to create - 1 for desktop and 1 for mobile - removed at runtime -->
		<xsl:variable name="matchingOutputTypeDesktop">
			<xsl:call-template name="determineMatchingOutputForDesktop">
				<xsl:with-param name="matchingNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="matchingOutputTypeMobile">
			<xsl:call-template name="determineMatchingOutputForMobile">
				<xsl:with-param name="matchingNode" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$matchingOutputTypeDesktop='rcfMatching'">
				<xsl:apply-templates select="." mode="standardMatching">
					<xsl:with-param name="targetDisplay" select="'desktop'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$matchingOutputTypeDesktop='rcfRotatingMatching'">
				<xsl:apply-templates select="." mode="rotatingMatching">
					<xsl:with-param name="targetDisplay" select="'desktop'"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="$matchingOutputTypeMobile='rcfMatching'">
				<xsl:apply-templates select="." mode="standardMatching">
					<xsl:with-param name="targetDisplay" select="'mobile'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$matchingOutputTypeMobile='rcfRotatingMatching'">
				<xsl:apply-templates select="." mode="rotatingMatching">
					<xsl:with-param name="targetDisplay" select="'mobile'"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="complexMatching">
		<xsl:apply-templates select="." mode="standardMatching"/>
	</xsl:template>


	<xsl:template match="matching | complexMatching" mode="standardMatching">
		<xsl:param name="targetDisplay" select="''"/>

		<xsl:variable name="activityId"><xsl:value-of select="ancestor::activity/@id"/></xsl:variable>
		<xsl:variable name="complexClass">
			<xsl:if test="name() = 'complexMatching'">complex</xsl:if>
		</xsl:variable>
		<xsl:variable name="ancestorID"><xsl:value-of select="@id"/></xsl:variable>

		<xsl:variable name="matchingExampleClass">
			<xsl:choose>
				<xsl:when test="@example='y'">example</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="orientClass">
			<xsl:choose>
				<xsl:when test="not(@display='h')">vertical</xsl:when>
				<xsl:otherwise>horizontal</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="matchingContainerContentStyles">
			<xsl:call-template name="getMatchingContentStyles"/>
		</xsl:variable>

		<div data-rcfinteraction="matching" data-rcfid="{@id}"
			class="{normalize-space(concat('matchingContainer ', $matchingContainerContentStyles, ' ', $complexClass, ' ', 'lastChild', ' ', @class, ' ', $orientClass, ' ', $matchingExampleClass))}"
		>
			<xsl:if test="not($targetDisplay='')">
				<xsl:attribute name="data-rcfTargetDisplay"><xsl:value-of select="$targetDisplay"/></xsl:attribute>
			</xsl:if>

			<xsl:attribute name="data-display">
				<xsl:choose>
					<xsl:when test="@display"><xsl:value-of select="@display"/></xsl:when>
					<xsl:otherwise>v</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="data-draggable">
				<xsl:choose>
					<xsl:when test="ancestor::activity/@desktopDraggable='n'">n</xsl:when>
					<xsl:when test="@clickStick='y'">n</xsl:when>
					<xsl:otherwise>y</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<div class="matchItems">
				<xsl:for-each select="distractors/item">
					<xsl:variable name="contentClasses">
						<xsl:call-template name="elementContentStylingClasses">
							<xsl:with-param name="contentElement" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<div class="{normalize-space(concat('matchItemContainer ', @class, ' ', $contentClasses))}">
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<div data-rcfid="{@id}"
							class="{normalize-space(concat('matchItem distractor dev-matchable-element ', @class))}"
							id="{$activityId}_{$ancestorID}_{@id}"
							data-matchTarget-rcfid="{$activityId}_{$ancestorID}_distractor"
						>
							<xsl:apply-templates/>
						</div>
					</div>
				</xsl:for-each>

				<xsl:for-each select=".//matchItem">
					<xsl:variable name="matchItemExampleClass">
						<xsl:choose>
							<xsl:when test="@example='y' or ancestor::pair/@example='y' or ancestor::matching/@example='y' or ancestor::complexMatching/@example='y'">example</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="contentClasses">
						<xsl:call-template name="elementContentStylingClasses">
							<xsl:with-param name="contentElement" select="."/>
						</xsl:call-template>
					</xsl:variable>

					<div class="{normalize-space(concat('matchItemContainer ', @class, ' ', $contentClasses, ' ', $matchItemExampleClass))}">
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<div data-rcfid="{@id}"
							class="{normalize-space(concat('matchItem dev-matchable-element', ' ', @class, ' ', $matchItemExampleClass))}"
							id="{$activityId}_{$ancestorID}_{@id}"
						>
							<xsl:apply-templates/>
						</div>
					</div>

				</xsl:for-each>
			</div>

			<div class="matchTargets">
				<xsl:if test="count(distractors/item)>0">
					<div class="matchTargetContainer distractor dev-markable-container">
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<div
							data-rcfid="{$activityId}_{@id}_distractor"
							class="matchTarget distractor dev-matchable-element"
							id="{$activityId}_{$ancestorID}_distractor"
						>distractor target</div>
					</div>
				</xsl:if>

				<xsl:for-each select=".//matchTarget">
					<xsl:variable name="matchTargetExampleClass">
						<xsl:choose>
							<xsl:when test="@example='y' or ancestor::pair/@example='y' or ancestor::matching/@example='y'">example</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="contentClasses">
						<xsl:call-template name="elementContentStylingClasses">
							<xsl:with-param name="contentElement" select="."/>
						</xsl:call-template>
					</xsl:variable>

					<div class="{normalize-space(concat('matchTargetContainer dev-markable-container ', @class, ' ', $contentClasses, ' ', $matchTargetExampleClass))}">
						<xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<xsl:if test="ancestor::pair/@correctFeedbackAudio"><xsl:attribute name="data-correctfeedbackaudio"><xsl:value-of select="ancestor::pair/@correctFeedbackAudio"/></xsl:attribute></xsl:if>
						<div class="markContainer">
							<span class="mark">&#160;&#160;&#160;&#160;</span>
						</div>
						<xsl:variable name="matchItemIDs">
							<xsl:choose>
								<xsl:when test="ancestor::complexMatching"><xsl:for-each select="acceptable/item"><xsl:value-of select="@id"/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each></xsl:when>
								<xsl:otherwise><xsl:value-of select="../matchItem/@id"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<div data-rcfid="{@id}"
							class="{normalize-space(concat('matchTarget dev-matchable-element ', @class, ' ', $matchTargetExampleClass))}"
							id="{$activityId}_{$ancestorID}_{@id}"
							data-matchItem-rcfid="{$matchItemIDs}"
						>
							<xsl:apply-templates/>
						</div>
					</div>

				</xsl:for-each>
			</div>

		</div>
	</xsl:template>

	<xsl:template match="matching" mode="rotatingMatching">
		<xsl:param name="targetDisplay" select="''"/>

        <xsl:variable name="activityId"><xsl:value-of select="ancestor::activity/@id"/></xsl:variable>

		<xsl:variable name="ancestorID"><xsl:value-of select="@id"/></xsl:variable>

        <xsl:variable name="matchingExampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>

        <xsl:variable name="matchingContainerContentStyles">
			<xsl:call-template name="getMatchingContentStyles"/>
		</xsl:variable>

        <div data-rcfinteraction="rotatingMatching" data-rcfid="{@id}"
        	class="{normalize-space(concat('rotatingMatchingContainer ', $matchingContainerContentStyles, ' ', 'lastChild', ' ', @class, ' ', $matchingExampleClass))}"
        >
			<xsl:if test="not($targetDisplay='')">
				<xsl:attribute name="data-rcfTargetDisplay"><xsl:value-of select="$targetDisplay"/></xsl:attribute>
			</xsl:if>

            <div class="rotatingMatchItems">
                <xsl:for-each select=".//matchItem">
                    <xsl:variable name="matchItemExampleClass">
                        <xsl:if test="@example='y' or ancestor::pair/@example='y' or ancestor::rotatingMatching/@example='y'">example</xsl:if>
                    </xsl:variable>

                    <xsl:variable name="contentClasses">
                        <xsl:call-template name="elementContentStylingClasses">
                            <xsl:with-param name="contentElement" select="."/>
                        </xsl:call-template>
                    </xsl:variable>

                    <div class="{normalize-space(concat('rotatingMatchItemContainer ', @class, ' ', $contentClasses, ' ', $matchItemExampleClass))}">
                        <xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
						<div class="markContainer">
                            <span class="mark">&#160;&#160;&#160;&#160;</span>
                        </div>
                        <div data-rcfid="{@id}"
                            class="{normalize-space(concat('rotatingMatchItem dev-matchable-element', ' ', @class, ' ', $matchItemExampleClass))}"
                            id="{$activityId}_{$ancestorID}_{@id}"
                        >
                            <xsl:apply-templates/>
                        </div>
                    </div>

                </xsl:for-each>
            </div>

            <div class="connectButton">
                <button class="connect" type="button">
					<span class="connectText hidden connect" data-rcfTranslate="">[ interactions.rotatingMatching.connect ]</span>
					<span class="connectText hidden disconnect" data-rcfTranslate="">[ interactions.rotatingMatching.disconnect ]</span>
                    <span class="connectIcon"></span>
                </button>
            </div>

            <div class="rotatingMatchTargets">
				<xsl:for-each select="distractors/item">
                    <xsl:variable name="contentClasses">
                        <xsl:call-template name="elementContentStylingClasses">
                            <xsl:with-param name="contentElement" select="."/>
                        </xsl:call-template>
                    </xsl:variable>
                    <div class="{normalize-space(concat('rotatingMatchTargetContainer ', @class, ' ', $contentClasses))}">
                        <xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
                        <div data-rcfid="{@id}"
                            class="{normalize-space(concat('rotatingMatchTarget distractor dev-matchable-element ', @class))}"
                            id="{$activityId}_{$ancestorID}_{@id}"
                            data-matchTarget-rcfid="{$activityId}_{$ancestorID}_distractor"
                        >
                            <xsl:apply-templates/>
                        </div>
                    </div>
                </xsl:for-each>

                <xsl:for-each select=".//matchTarget">
                    <xsl:variable name="matchTargetExampleClass">
                        <xsl:choose>
                            <xsl:when test="@example='y' or ancestor::pair/@example='y' or ancestor::matching/@example='y'">example</xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="contentClasses">
                        <xsl:call-template name="elementContentStylingClasses">
                            <xsl:with-param name="contentElement" select="."/>
                        </xsl:call-template>
                    </xsl:variable>

                    <div class="{normalize-space(concat('rotatingMatchTargetContainer dev-markable-container ', @class, ' ', $contentClasses, ' ', $matchTargetExampleClass))}">
                        <xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
                        <xsl:if test="ancestor::pair/@correctFeedbackAudio"><xsl:attribute name="data-correctfeedbackaudio"><xsl:value-of select="ancestor::pair/@correctFeedbackAudio"/></xsl:attribute></xsl:if>
                        <xsl:variable name="matchItemIDs"><xsl:value-of select="../matchItem/@id"/></xsl:variable>
                        <div data-rcfid="{@id}"
                            class="{normalize-space(concat('rotatingMatchTarget dev-matchable-element ', @class, ' ', $matchTargetExampleClass))}"
                            id="{$activityId}_{$ancestorID}_{@id}"
                            data-matchItem-rcfid="{$matchItemIDs}"
                        >
                            <xsl:apply-templates/>
                        </div>
                    </div>

                </xsl:for-each>
            </div>
        </div>
    </xsl:template>

	<xsl:template name="getMatchingContentStyles">
		<xsl:param name="matchingNode" select="."/>

		<xsl:variable name="matchItemsText">
			<xsl:apply-templates select="$matchingNode//matchItem//text()"/>
			<xsl:apply-templates select="$matchingNode/distractors/item/text()"/>
		</xsl:variable>

		<xsl:variable name="matchTargetsText">
			<xsl:apply-templates select="$matchingNode//matchTarget//text()"/>
		</xsl:variable>

		<xsl:if test="count($matchingNode//matchItem//audio) + count($matchingNode//distractors/item/audio) &gt; 0">
			hasAudioItems
		</xsl:if>
		<xsl:if test="count($matchingNode//matchTarget//audio) &gt; 0">
			hasAudioTargets
		</xsl:if>
		<xsl:if test="count($matchingNode//matchItem//image) + count($matchingNode//matchItem/imageAudio) + count($matchingNode//distractors/item/imageAudio) &gt; 0">
			hasImageItems
		</xsl:if>
		<xsl:if test="count($matchingNode//matchTarget//image) + count($matchingNode//matchTarget/imageAudio) &gt; 0">
			hasImageTargets
		</xsl:if>
		<xsl:if test="normalize-space($matchItemsText) != ''">
			hasTextItems
		</xsl:if>
		<xsl:if test="normalize-space($matchTargetsText) != ''">
			hasTextTargets
		</xsl:if>
	</xsl:template>

	<xsl:template match="matching" mode="getRcfDesktopClassName">
		<xsl:call-template name="determineMatchingOutputForDesktop">
			<xsl:with-param name="matchingNode" select="."/>
		</xsl:call-template><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="matching" mode="getRcfMobileClassName">
		<xsl:call-template name="determineMatchingOutputForMobile">
			<xsl:with-param name="matchingNode" select="."/>
		</xsl:call-template><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template name="determineMatchingOutputForMobile">
		<xsl:param name="matchingNode"/>
		<xsl:choose>
			<xsl:when test="$matchingNode/@mobileDisplay='rotating'">rcfRotatingMatching</xsl:when>
			<xsl:when test="$matchingNode/@mobileDisplay='standard'">rcfMatching</xsl:when>
			<xsl:when test="$matchingNode/@displayType='' or $matchingNode/@displayType='standard' or not($matchingNode/@displayType)">rcfMatching</xsl:when>
			<xsl:otherwise>rcfRotatingMatching</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="determineMatchingOutputForDesktop">
		<xsl:param name="matchingNode"/>
		<xsl:choose>
			<xsl:when test="$matchingNode/@displayType='rotating'">rcfRotatingMatching</xsl:when>
			<xsl:when test="$matchingNode/@displayType='' or $matchingNode/@displayType='standard' or not($matchingNode/@displayType)">rcfMatching</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="complexMatching" mode="getRcfDesktopClassName">
		rcfMatching
	</xsl:template>

	<xsl:template match="complexMatching" mode="getRcfMobileClassName">
		rcfMatching
	</xsl:template>
</xsl:stylesheet>
