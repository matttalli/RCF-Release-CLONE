<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="story">
        <div class="{normalize-space(concat('story ', @class))}" data-rcfinteraction="story" data-ignoreNextAnswer="y">
            <!-- output scene elements in reverse order to allow stacking -->
            <xsl:apply-templates select="scene">
                <xsl:sort select="position()" data-type="number" order="descending"/>
            </xsl:apply-templates>
            <!-- output the cover -->
            <xsl:apply-templates select="cover"/>
            <!-- output the navigation buttons -->
            <xsl:call-template name="outputStoryNavigation"/>

            <!-- output the story audio player element - use this rather than the activity audio player -->
            <div class="storyAudioContainer audioContainer">
                <audio class="storyPlaybackAudioPlayer" />
            </div>

        </div>
    </xsl:template>

    <xsl:template match="cover">
        <xsl:variable name="coverImageSource">
            <xsl:call-template name="getImageSource">
                <xsl:with-param name="sourceValue" select="@image"/>
            </xsl:call-template>
        </xsl:variable>

        <div class="{normalize-space(concat('cover ', @class))}">
            <img src="{$coverImageSource}" />
            <div class="modes">
                <ul>
                    <li class="button active read" data-mode="read"><a data-rcfTranslate="">[ interactions.story.read ]</a></li>
                    <li class="button active listen" data-mode="listen"><a data-rcfTranslate="">[ interactions.story.listen ]</a></li>
                    <li class="button active listenRead" data-mode="listenRead"><a data-rcfTranslate="">[ interactions.story.listenAndRead ]</a></li>
                </ul>
            </div>
        </div>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="story/scene">
        <xsl:variable name="sceneClass">
            <xsl:if test="questions"><xsl:text> </xsl:text>comprehension</xsl:if>
        </xsl:variable>

        <xsl:variable name="sceneImageUrl">
            <xsl:call-template name="getImageSource">
                <xsl:with-param name="sourceValue" select="@image"/>
            </xsl:call-template>
        </xsl:variable>

        <div data-rcfid="{@id}" class="{normalize-space(concat('scene ', @class, ' ', $sceneClass))}">
            <xsl:if test="sceneAudio or count(speech/@audio)>0">
                <div class="hiddenAudio">
                    <xsl:apply-templates select="sceneAudio | speech" mode="hiddenAudio"/>
                </div>
            </xsl:if>
            <div class="frame">
                <xsl:choose>
                    <xsl:when test="sceneAudio">
                        <img src="{$sceneImageUrl}" data-rcfid="sceneAudio" data-speechid="sceneAudio" class="sceneImage sceneAudio dev-scenePlayableElement" data-speechaudio="{sceneAudio/@src}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <img src="{$sceneImageUrl}" class="sceneImage"/>
                    </xsl:otherwise>
                </xsl:choose>
                <div class="sceneSpeech">
                    <xsl:apply-templates select="speech"/>
                </div>
            </div>
            <xsl:apply-templates select="questions"/>
        </div>
    </xsl:template>

    <xsl:template match="sceneAudio" mode="hiddenAudio">
        <xsl:if test="@src">
            <xsl:variable name="audioSource">
                <xsl:call-template name="getAudioSource">
                    <xsl:with-param name="sourceValue" select="@src"/>
                </xsl:call-template>
            </xsl:variable>
            <audio class="storyAudio sceneAudio" data-speechid="sceneAudio" preload="none">
                <source src="{$audioSource}"/>
            </audio>
        </xsl:if>
    </xsl:template>

    <xsl:template match="speech" mode="hiddenAudio">
        <xsl:if test="@audio">
            <xsl:variable name="audioSource">
                <xsl:call-template name="getAudioSource">
                    <xsl:with-param name="sourceValue" select="@audio"/>
                </xsl:call-template>
            </xsl:variable>
            <audio class="storyAudio speechAudio" data-speechid="{@id}" data-delaybefore="{@delayBefore}" data-delayafter="{@delayAfter}" preload="none">
                <source src="{$audioSource}"/>
            </audio>
        </xsl:if>
    </xsl:template>

    <xsl:template match="speech">
        <xsl:variable name="speechClass" select="@class"/>
        <xsl:variable name="speechAudioClass">
            <xsl:if test="@audio"><xsl:text> </xsl:text>speechAudio hasAudio</xsl:if>
        </xsl:variable>
        <xsl:variable name="tipClass">
            <xsl:choose>
                <xsl:when test="@tip"> tip<xsl:value-of select="translate(substring(@tip, 1,1), $lowercase, $uppercase)"/><xsl:value-of select="substring(@tip, 2)"/></xsl:when>
                <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="speakerId" select="@speakerId"/>
        <xsl:variable name="currentSpeaker" select="ancestor::story/speakersList/speaker[@id=$speakerId]"/>
        <xsl:variable name="speechBubbleColour">
            <xsl:if test="$currentSpeaker/@bubbleColour">
                bubbleColour-<xsl:value-of select="$currentSpeaker/@bubbleColour"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="sideClass">
            <xsl:choose>
                <xsl:when test="@side='left'">sideLeft</xsl:when>
                <xsl:when test="@side='right'">sideRight</xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div data-rcfid="{@id}"
            class="{normalize-space(concat('speech dev-scenePlayableElement ', @type, ' ', $speechClass, ' ', $speechAudioClass, ' ', $tipClass, ' ', $sideClass, ' ', $speechBubbleColour))}" style="left:{@x}px;top:{@y}px;">
            <xsl:if test="@audio">
                <xsl:attribute name="data-speechaudio">
                    <xsl:value-of select="@audio"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@delayBefore">
                <xsl:attribute name="data-delaybefore">
                    <xsl:value-of select="@delayBefore"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@delayAfter">
                <xsl:attribute name="data-delayafter">
                    <xsl:value-of select="@delayAfter"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@speakerId">
                <xsl:attribute name="data-speakerid">
                    <xsl:value-of select="@speakerId"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$currentSpeaker">
                    <xsl:if test="$currentSpeaker[@avatar and string-length(@avatar)!=0]">
                        <xsl:variable name="speakerAvatarSource">
                            <xsl:call-template name="getImageSource">
                                <xsl:with-param name="sourceValue" select="$currentSpeaker/@avatar"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <img src="{$speakerAvatarSource}" class="speakerAvatar"/>
                    </xsl:if>
                    <p>
                        <xsl:if test="$currentSpeaker/@name">
                            <span class="speakerName"><xsl:value-of select="$currentSpeaker/@name"/>: </span>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </p>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="story/scene/questions">
        <div class="{normalize-space(concat('questions ', @class))}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="story/scene/questions/question">
        <div data-rcfid="{@id}" class="{normalize-space(concat('question ', @class))}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template name="outputStoryNavigation">
        <div class="navigation">
            <ul>
                <li class="button back" data-mode="previous"><a href="" data-rcfTranslate="">[ components.button.back ]</a></li>
                <li class="button next" data-mode="next"><a href="" data-rcfTranslate="">[ components.button.next ]</a></li>
            </ul>
        </div>
    </xsl:template>

    <!-- rcf_story -->
    <xsl:template match="story" mode="getRcfClassName">
        rcfStory
        <xsl:apply-templates mode="getRcfClassName"/>
    </xsl:template>

</xsl:stylesheet>
