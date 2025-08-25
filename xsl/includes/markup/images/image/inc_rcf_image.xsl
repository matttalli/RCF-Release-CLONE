<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- when the image has a caption, or description, or both, we need to add an image container and child containers -->
    <xsl:template match="image[./caption or ./description] | activityImage[./caption or ./description]">
        <xsl:variable name="captionClass">
            <xsl:if test="./caption">imageCaption</xsl:if>
        </xsl:variable>

        <xsl:variable name="descriptionClass">
            <xsl:if test="./description">hasImageDescription</xsl:if>
        </xsl:variable>

        <xsl:variable name="panZoomClass">
            <xsl:if test="@panzoom='inplace'">panzoomContainer hasPanZoomInPlaceUI</xsl:if>
            <xsl:if test="@panzoom='popup'">panzoomContainer hasPanZoomPopupUI</xsl:if>
        </xsl:variable>

        <xsl:variable name="ariaLabel">
            <xsl:if test="@panzoom='inplace' or @panzoom='popup'">
                <xsl:value-of select="concat('[ interactions.panzoom.instruction ] ', @a11yTitle)"/>
            </xsl:if>
            <xsl:if test="(@panzoom='inplace' or @panzoom='popup') and ./description and normalize-space(./description)!=''">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="./description and normalize-space(./description)!=''">
                <xsl:value-of select="normalize-space(./description)"/>
            </xsl:if>
        </xsl:variable>

        <span class="{normalize-space(concat('imageContainer ', $captionClass, ' ', $descriptionClass, ' ', $panZoomClass))}">
            <xsl:attribute name="role">figure</xsl:attribute>
            <xsl:if test="@panzoom='inplace' or @panzoom='popup'">
                <xsl:attribute name="data-rcfTranslate"></xsl:attribute>
            </xsl:if>
            <xsl:if test="normalize-space($ariaLabel) != ''">
                <xsl:attribute name="aria-label">
                    <xsl:value-of select="normalize-space($ariaLabel)"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="@panzoom='inplace'">
                    <span class="imageInnerContainer">
                        <span class="panzoomImageContainer">
                            <xsl:apply-templates select="." mode="outputImage"/>
                        </span>

                        <xsl:call-template name="imageControls">
                            <xsl:with-param name="panzoomType" select="'inplace'"/>
                        </xsl:call-template>
                    </span>
                </xsl:when>
                <xsl:when test="@panzoom='popup'">
                    <span class="imageInnerContainer">
                        <span class="panzoomImageContainer">
                            <xsl:apply-templates select="." mode="outputImage"/>
                        </span>

                        <xsl:call-template name="imageControls">
                            <xsl:with-param name="panzoomType" select="'popup'"/>
                        </xsl:call-template>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="outputImage"/>
                </xsl:otherwise>
            </xsl:choose>

            <span class="infoInnerContainer">
                <xsl:apply-templates />
            </span>
        </span>
    </xsl:template>

	<!-- handling for images without captions / descriptions -->
    <xsl:template match="image[not(./caption) and not(./description)] | activityImage[not(./caption) and not(./description)]">
        <xsl:choose>
            <xsl:when test="@panzoom='inplace'">
                <span class="imageContainer panzoomContainer hasPanZoomInPlaceUI">
                    <xsl:attribute name="role">figure</xsl:attribute>
                    <xsl:attribute name="data-rcfTranslate"></xsl:attribute>
                    <xsl:attribute name="aria-label">
                        <xsl:value-of select="concat('[ interactions.panzoom.instruction ] ', @a11yTitle)"/>
                    </xsl:attribute>
                    <span class="imageInnerContainer">
                        <span class="panzoomImageContainer">
                            <xsl:apply-templates select="." mode="outputImage"/>
                        </span>

                        <xsl:call-template name="imageControls">
                            <xsl:with-param name="panzoomType" select="'inplace'"/>
                        </xsl:call-template>
                    </span>
                </span>
            </xsl:when>
            <xsl:when test="@panzoom='popup'">
                <span class="imageContainer panzoomContainer hasPanZoomPopupUI">
                    <xsl:attribute name="role">figure</xsl:attribute>
                    <xsl:attribute name="data-rcfTranslate"></xsl:attribute>
                    <xsl:attribute name="aria-label">
                        <xsl:value-of select="concat('[ interactions.panzoom.instruction ] ', @a11yTitle)"/>
                    </xsl:attribute>
                    <span class="imageInnerContainer">
                        <span class="panzoomImageContainer">
                            <xsl:apply-templates select="." mode="outputImage"/>
                        </span>

                        <xsl:call-template name="imageControls">
                            <xsl:with-param name="panzoomType" select="'popup'"/>
                        </xsl:call-template>
                    </span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="outputImage"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="image/caption">
        <span class="{normalize-space(concat('caption ', @type))}">
            <xsl:if test="@lang">
                <xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
            </xsl:if>

            <span class="innerCaption">
                <xsl:apply-templates/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="image/description">
        <span class="{normalize-space(concat('description ', @type))}">
            <xsl:if test="@lang">
                <xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
            </xsl:if>

            <span class="innerDescription">
                <xsl:attribute name="id">
                    <xsl:call-template name="generate-unique-description-id"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </span>
        </span>
    </xsl:template>

    <xsl:template name="generate-unique-image-id">
        <xsl:variable name="activityId" select="ancestor::activity/@id"/>
        <xsl:variable name="imageIndexInActivity">
            <xsl:number count="image[@panzoom='inplace' or @panzoom='popup']" from="activity" level="any"/>
        </xsl:variable>
        <xsl:value-of select="concat('panzoomimage_', $activityId, '_', $imageIndexInActivity)"/>
    </xsl:template>

    <xsl:template name="generate-unique-description-id">
        <xsl:variable name="activityId" select="ancestor::activity/@id"/>
        <xsl:variable name="imageIndexInActivity">
            <xsl:number count="image[./description]" from="activity" level="any"/>
        </xsl:variable>
        <xsl:value-of select="concat('imagedescription_', $activityId, '_', $imageIndexInActivity)"/>
    </xsl:template>

    <xsl:template match="image" mode="outputImage">
        <xsl:variable name="imageClass">
            <xsl:if test="not(@class='')"><xsl:value-of select="@class"/><xsl:text> </xsl:text></xsl:if>
            <xsl:if test="@panzoom='inplace'"><xsl:text> </xsl:text>panzoomimage panzoom-inplace</xsl:if>
            <xsl:if test="@panzoom='popup'"><xsl:text> </xsl:text>panzoomimage panzoom-popup</xsl:if>
        </xsl:variable>
        <xsl:variable name="imageSrc">
            <xsl:call-template name="getAssetSource">
                <xsl:with-param name="assetSource" select="@src"/>
                <xsl:with-param name="useEnvironment" select="$environment"/>
                <xsl:with-param name="assetPartialPathName" select="'images'"/>
                <xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
            </xsl:call-template>
        </xsl:variable>

        <img src="{$imageSrc}">
            <xsl:if test="@a11yTitleLang">
                <xsl:attribute name="lang"><xsl:value-of select="@a11yTitleLang"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@title and not(@title='')">
                <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@a11yTitle">
                <xsl:attribute name="alt"><xsl:value-of select="@a11yTitle"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="normalize-space($imageClass)!=''">
                <xsl:attribute name="class"><xsl:value-of select="normalize-space($imageClass)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@panzoom='inplace'">
                 <xsl:attribute name="data-rcfinteraction">panZoomImage</xsl:attribute>
                 <xsl:attribute name="data-rcfid">
                     <xsl:call-template name="generate-unique-image-id"/>
                 </xsl:attribute>
                 <xsl:attribute name="data-ignoreNextAnswer">y</xsl:attribute>
                 <xsl:attribute name="tabindex">0</xsl:attribute>
            </xsl:if>
            <xsl:if test="@panzoom='popup'">
                 <xsl:attribute name="data-rcfinteraction">panZoomImage</xsl:attribute>
                 <xsl:attribute name="data-rcfid">
                     <xsl:call-template name="generate-unique-image-id"/>
                 </xsl:attribute>
                 <xsl:attribute name="data-ignoreNextAnswer">y</xsl:attribute>
            </xsl:if>
            <xsl:if test="@triggerClass">
                <xsl:attribute name="data-rcfinteraction">triggerableElement</xsl:attribute>
                <xsl:attribute name="data-ignoreNextAnswer">y</xsl:attribute>
                <xsl:attribute name="data-rcfInitialisePriority">-1</xsl:attribute>
                <xsl:attribute name="data-triggerable">y</xsl:attribute>
                <xsl:attribute name="data-triggerClass"><xsl:value-of select="@triggerClass"/></xsl:attribute>
                <xsl:attribute name="data-triggerLoop"><xsl:value-of select="@triggerLoop"/></xsl:attribute>
                <xsl:attribute name="data-triggerNumber"><xsl:value-of select="@triggerNumber"/></xsl:attribute>
                <xsl:attribute name="data-triggerExclusive"><xsl:value-of select="@triggerExclusive"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@decorative='y'">
                <xsl:attribute name="role">presentation</xsl:attribute>
            </xsl:if>
            <xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
        </img>
    </xsl:template>

    <xsl:template match="image[@panzoom='inplace']" mode="getUnmarkedInteractionName">
        rcfPanZoom
    </xsl:template>

    <xsl:template match="image[ancestor::activity[@preProcessed='y']]">
        <xsl:choose>
            <xsl:when test="@panzoom='y' or @panzoom='default' or not(@panzoom)">
                <xsl:apply-templates select="." mode="outputImage"/>
            </xsl:when>
            <xsl:when test="@panzoom='inplace' or @panzoom='popup'">
                <xsl:choose>
                    <xsl:when test="caption">
                        <span class="imageContainer imageCaption">
                            <xsl:apply-templates select="." mode="outputImage"/>
                            <span class="{normalize-space(concat('caption ', @type))}">
                                <span class="innerCaption">
                                    <xsl:apply-templates select="caption" mode="outputCaption"/>
                                </span>
                            </span>
                            <xsl:if test="description">
                                <span class="{normalize-space(concat('description ', @type))}">
                                    <span class="innerDescription">
                                        <xsl:apply-templates select="description"/>
                                    </span>
                                </span>
                            </xsl:if>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="outputImage"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="imageControls">
        <xsl:param name="panzoomType" />
		<!-- When changing panzoom controls remember to update  initialisePanzoomInstanceOnElement.js and createPanzoomModal.js files -->
        <span class="imageControls clearfix">
        <xsl:choose>
            <xsl:when test="$panzoomType = 'inplace'">
                <span class="panzoomControls">
                    <span class="buttons controlsContainer panzoom">
                        <button class="controlsButton panzoomOut">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-popup-minus" class="mm_btn_icon mm_btn_icon_minus">
                                    <rect x="45" y="29.77" width="10" height="40.47" rx="3.47" ry="3.47" transform="translate(0 100) rotate(-90)" style="stroke-width: 0px;"/>
                                </g>
                            </svg>
                            <span class="visually-hidden" data-rcfTranslate="">[ interactions.panzoom.zoomOut ]</span>
                        </button>
                        <button class="controlsButton panzoomIn">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-popup-plus" class="mm_btn_icon mm_btn_icon_plus">
                                    <path d="m70.23,48.47v3.06c0,1.92-1.55,3.47-3.47,3.47h-11.76v11.77c0,1.91-1.56,3.47-3.47,3.47h-3.07c-1.91,0-3.46-1.56-3.46-3.47v-11.77h-11.77c-1.92,0-3.47-1.55-3.47-3.47v-3.06c0-1.91,1.55-3.47,3.47-3.47h11.77v-11.76c0-1.92,1.55-3.47,3.46-3.47h3.07c1.91,0,3.47,1.55,3.47,3.47v11.76h11.76c1.92,0,3.47,1.56,3.47,3.47Z" style="stroke-width: 0px;"/>
                                </g>
                            </svg>
                            <span class="visually-hidden" data-rcfTranslate="">[ interactions.panzoom.zoomIn ]</span>
                        </button>
                        <input class="range-input controls" type="range" min="1" max="3" step="0.2" value="1" data-rcfTranslate="" aria-label="[ interactions.panzoom.zoomRangeSlider ]"/>
                        <button class="controlsButton panzoomReset">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-popup-reset" class="mm_btn_icon mm_btn_icon_reset">
                                    <path d="m73.54,55.85c-1.56,5.84-5.3,10.72-10.53,13.74-3.49,2.01-7.35,3.04-11.27,3.04-1.97,0-3.94-.26-5.89-.78-2.14-.58-3.4-2.77-2.83-4.9.57-2.14,2.76-3.41,4.9-2.83,3.77,1.01,7.71.49,11.09-1.46,3.38-1.95,5.8-5.11,6.81-8.88,1.01-3.77.49-7.71-1.46-11.09s-5.11-5.79-8.88-6.8c-7.48-2.01-15.21,2.2-17.63,9.47l6.3-2.91c2-.93,4.38-.05,5.31,1.96.92,2,.05,4.38-1.96,5.3l-16.04,7.41-8.69-14.9c-1.11-1.91-.46-4.36,1.44-5.47,1.91-1.11,4.36-.47,5.47,1.44l1.44,2.46c4.48-9.89,15.61-15.39,26.43-12.49,5.84,1.56,10.72,5.3,13.74,10.53,3.02,5.24,3.82,11.33,2.25,17.16Z" style="stroke-width: 0px;"/>
                                </g>
                            </svg>
                            <span class="visually-hidden" data-rcfTranslate="">[ interactions.panzoom.reset ]</span>
                        </button>
                    </span>
                </span>
                <xsl:if test="description">
                    <button class="imageDescriptionToggle controlsButton">
                        <span class="showImageDescriptionLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-description-show" class="mm_btn_icon mm_btn_icon_show">
                                    <circle cx="50" cy="30.01" r="6.04" style="stroke-width: 0px;"/>
                                    <rect x="45.04" y="46.08" width="10" height="28.97" rx="3.47" ry="3.47" style="stroke-width: 0px;"/>
                                </g>
                            </svg>
                        </span>
                        <span class="hideImageDescriptionLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-description-hide" class="mm_btn_icon mm_btn_icon_hide">
                                    <circle cx="50" cy="29.88" r="6.04" style="stroke-width: 0px;"/>
                                    <path d="m48.51,45.96h0c3.61,0,6.53,2.93,6.53,6.53v18.97c0,1.91-1.55,3.47-3.47,3.47h-3.06c-1.91,0-3.47-1.55-3.47-3.47v-22.04c0-1.91,1.55-3.47,3.47-3.47Z" style="stroke-width: 0px;"/>
                                    <rect x="46" y="14.76" width="8" height="70.48" rx="4" ry="4" transform="translate(-20.71 50) rotate(-45)" style="stroke-width: 0px;" class="mm_btn_icon_hide_strike"/>
                                </g>
                            </svg>
                        </span>
                        <span class="visually-hidden imageDescriptionLabelText" data-rcfTranslate="">[ interactions.panzoom.openDescription ]</span>
                    </button>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$panzoomType = 'popup'">
                <xsl:if test="description">
                    <button class="imageDescriptionToggle controlsButton">
                        <span class="showImageDescriptionLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-description-show" class="mm_btn_icon mm_btn_icon_show">
                                    <circle cx="50" cy="30.01" r="6.04" style="stroke-width: 0px;"/>
                                    <rect x="45.04" y="46.08" width="10" height="28.97" rx="3.47" ry="3.47" style="stroke-width: 0px;"/>
                                </g>
                            </svg>
                        </span>
                        <span class="hideImageDescriptionLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                <g id="image-description-hide" class="mm_btn_icon mm_btn_icon_hide">
                                    <circle cx="50" cy="29.88" r="6.04" style="stroke-width: 0px;"/>
                                    <path d="m48.51,45.96h0c3.61,0,6.53,2.93,6.53,6.53v18.97c0,1.91-1.55,3.47-3.47,3.47h-3.06c-1.91,0-3.47-1.55-3.47-3.47v-22.04c0-1.91,1.55-3.47,3.47-3.47Z" style="stroke-width: 0px;"/>
                                    <rect x="46" y="14.76" width="8" height="70.48" rx="4" ry="4" transform="translate(-20.71 50) rotate(-45)" style="stroke-width: 0px;" class="mm_btn_icon_hide_strike"/>
                                </g>
                            </svg>
                        </span>
                        <span class="visually-hidden" data-rcfTranslate="">[ interactions.panzoom.openDescription ]</span>
                    </button>
                </xsl:if>

                <button class="panzoomPopupToggle controlsButton">
                    <xsl:attribute name="data-rcf-imageid">
                        <xsl:call-template name="generate-unique-image-id"/>
                    </xsl:attribute>
                    <span class="showImagePopupLabel">
                        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 100 100">
                            <g id="img-popup-fullscreen-enter" class="mm_btn_icon mm_btn_icon_fullscreen_enter">
                                <path d="M84.14,88.12c-1.02,0-2.04-.39-2.82-1.17l-13.83-13.83c-5.85,4.64-13.25,7.41-21.28,7.41-18.93,0-34.33-15.4-34.33-34.33S27.28,11.88,46.21,11.88s34.33,15.4,34.33,34.33c0,8.03-2.77,15.43-7.41,21.28l13.83,13.83c1.55,1.56,1.55,4.08,0,5.63-.78.78-1.8,1.17-2.82,1.17ZM46.21,19.84c-14.54,0-26.36,11.83-26.36,26.36s11.83,26.36,26.36,26.36c7.12,0,13.59-2.84,18.34-7.44.09-.11.18-.21.28-.31.1-.1.2-.19.31-.28,4.6-4.75,7.44-11.22,7.44-18.34,0-14.54-11.83-26.36-26.36-26.36ZM46.21,61.57c-2.2,0-3.98-1.78-3.98-3.98v-7.4h-7.4c-2.2,0-3.98-1.78-3.98-3.98s1.78-3.98,3.98-3.98h7.4v-7.4c0-2.2,1.78-3.98,3.98-3.98s3.98,1.78,3.98,3.98v7.4h7.4c2.2,0,3.98,1.78,3.98,3.98s-1.78,3.98-3.98,3.98h-7.4v7.4c0,2.2-1.78,3.98-3.98,3.98Z"/>
                            </g>
                        </svg>
                    </span>
                    <span class="visually-hidden" data-rcfTranslate="">[ interactions.panzoom.openPopup ]</span>
                </button>
            </xsl:when>
        </xsl:choose>
        </span>
    </xsl:template>

</xsl:stylesheet>
