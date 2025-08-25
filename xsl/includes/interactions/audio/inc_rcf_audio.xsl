<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- -->
	<xsl:template match="audio[not(@size)]">
		<xsl:choose>
			<xsl:when test="ancestor::rubric"><xsl:comment>defaulting to full size player</xsl:comment><xsl:apply-templates select="." mode="fullPlayer"/></xsl:when>
			<xsl:otherwise><xsl:comment>defaulting to small player</xsl:comment><xsl:apply-templates select="." mode="smallPlayer"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="audio[@size='large']">
		<xsl:apply-templates select="." mode="fullPlayer"/>
	</xsl:template>

	<xsl:template match="audio[@size='small']">
		<xsl:apply-templates select="." mode="smallPlayer" />
	</xsl:template>

	<xsl:template match="audio" mode="smallPlayer">
		<xsl:variable name="apID">audio_<xsl:value-of select="count(preceding::audio)+1"/></xsl:variable>
		<xsl:variable name="trackSrc"><xsl:value-of select="track[1]/@src"/></xsl:variable>

		<xsl:variable name="hasRecordingOption">
			<xsl:if test="not(@recording='n') and ($alwaysAddRecordingButton='y' or @recording='y')">y</xsl:if>
		</xsl:variable>

		<xsl:variable name="recordingClass">
			<xsl:if test="$hasRecordingOption='y'">hasRecordingButton</xsl:if>
		</xsl:variable>

		<xsl:if test="@title">
			<span id="audioTitle_{$apID}" class="audioTitle"><xsl:value-of select="@title"/></span>
		</xsl:if>

		<xsl:variable name="prefixAudioId">
			<xsl:choose>
				<xsl:when test="ancestor::activity"><xsl:value-of select="ancestor::activity/@id"/></xsl:when>
				<xsl:when test="ancestor::item[parent::itemList]"><xsl:value-of select="ancestor::item[parent::itemList]/@id"/></xsl:when>
				<xsl:otherwise>_closest_<xsl:value-of select="preceding::*[@id][1]/@id"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<span data-rcfinteraction="inlineAudioElement"
			data-ignoreNextAnswer="y"
			class="inlinePlayerContainer {$recordingClass}"
			data-audiolinkid="{$prefixAudioId}_{$apID}"
			data-audiolink="{$trackSrc}"
		>
			<xsl:if test="@a11yTitle">
				<xsl:attribute name="aria-label"><xsl:value-of select="@a11yTitle"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="@a11yTitleLang">
				<xsl:attribute name="lang"><xsl:value-of select="@a11yTitleLang" /></xsl:attribute>
			</xsl:if>

			<span class="inlinePlayer">
				<button class="audioPlayButton" tabindex="0" type="button">
					<xsl:call-template name="audioPlayIcon"/>
					<xsl:call-template name="audioStopIcon"/>
					<span class="audioPlayButtonPlayLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.play ]</span>
					<span class="audioPlayButtonStopLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.stop ]</span>
				</button>
			</span>

			<xsl:if test="$hasRecordingOption='y'">
				<span data-rcfinteraction="audioRecorder" data-ignoreNextAnswer="y" class="inlineAudioRecordingContainer wasmRecording" >
					<xsl:attribute name="data-rcfid">smallrecorder_<xsl:value-of select="count(preceding::audio)+1"/></xsl:attribute>
					<span class="inlineAudioRecording">
						<button class="audioRecordButton" data-rcf-media="record" type="button">
							<xsl:call-template name="audioStartRecordIcon"/>
							<xsl:call-template name="audioStopRecordIcon"/>
							<span class="audioRecordButtonRecordLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.record ]</span>
							<span class="audioRecordButtonStopLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.stop ]</span>
						</button>
					</span>
					<span class="inlineAudioRecordingPlayback">
						<button class="inlineAudioRecordingPlayButton" data-rcf-media="playbackRecording" tabindex="0" type="button">
							<xsl:call-template name="audioPlayIcon"/>
							<xsl:call-template name="audioStopIcon"/>
							<span class="inlineAudioRecordingPlayButtonLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.play ]</span>
							<span class="inlineAudioRecordingStopButtonLabel visually-hidden" data-rcfTranslate="">[ interactions.audioplayer.stop ]</span>
						</button>
					</span>
					<audio class="playbackPlayer" crossorigin="" playsinline="" data-rcf-media="playbackAudioPlayer"></audio>
				</span>
			</xsl:if>

		</span>
	</xsl:template>

    <xsl:template name="createInlineAudioPlayer">
        <xsl:param name="audio"/>
		<xsl:param name="audioId"/>

		<span data-rcfinteraction="inlineAudioElement"
			data-ignoreNextAnswer="y"
			data-audiolink="{$audio}"
			class="inlinePlayerContainer"
			data-audiolinkid="{ancestor::activity/@id}-{$audioId}"
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

	<xsl:template match="audio" mode="fullPlayer">
		<!--
			February 2013

			- new 'audio' has at least one 'track' child element containing 'src', 'trackName' and 'pageRef'

		-->

		<!-- this holds the actual 'player' - whether it is a 'flash' player, or 'html'
			... if gets populated by the plyr code with the relevant content -->

		<!--  replace .mp3 for srtID  -->
		<xsl:variable name="trackSrc">
			<xsl:choose>
				<xsl:when test="count(track) > 0"><xsl:value-of select="track[1]/@src"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="sizeClass">
			<xsl:choose>
				<xsl:when test="not(@size)">large</xsl:when>
				<xsl:otherwise><xsl:value-of select="@size"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="subID">
			<xsl:choose>
				<xsl:when test="@srtSrc">
					<xsl:choose>
						<xsl:when test="$environment = 'capePreview'">
							<xsl:value-of select ="@srtSrc"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="stringreplace">
								<xsl:with-param name="stringvalue" select="@srtSrc" />
								<xsl:with-param name="from" select="'.srt'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- replace '.mp3' or '.ogg from the file name -->
					<xsl:call-template name="stringreplace">
						<xsl:with-param name="stringvalue">
							<xsl:call-template name="stringreplace">
								<xsl:with-param name="stringvalue" select="$trackSrc" />
								<xsl:with-param name="from" select="'.mp3'"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="from" select="'.ogg'"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="apID"><xsl:value-of select="ancestor::activity/@id"/>_fullAudio_<xsl:value-of select="count(preceding::audio)+1"/></xsl:variable>

		<!-- controls -->
		<xsl:variable name="audioClassExtra">
			<xsl:if test="@srt='n'">noSubtitles</xsl:if>
		</xsl:variable>

		<xsl:variable name="hasRecordingOption">
			<xsl:if test="not(@recording='n') and ($alwaysAddRecordingButton='y' or @recording='y')">y</xsl:if>
		</xsl:variable>

		<xsl:variable name="recordingClass">
			<xsl:if test="$hasRecordingOption='y'">hasRecordingButton</xsl:if>
		</xsl:variable>

		<xsl:variable name="noPrecedingOpenCC">
			<xsl:if test="count(preceding::audio[@openCC='y']) = 0  and @openCC='y'">y</xsl:if>
		</xsl:variable>

		<xsl:variable name="autoOpen">
			<xsl:if test="$noPrecedingOpenCC = 'y'">scriptOpen</xsl:if>
		</xsl:variable>

		<xsl:variable name="openStyle">
			<xsl:if test="$noPrecedingOpenCC = 'y'">display: block;</xsl:if>
		</xsl:variable>

		<div id="{ancestor::activity/@id}_lap_{count(preceding::audio)+1}"
			data-rcfinteraction="audioElement"
			data-ignoreNextAnswer="y"
			data-audiosrc="{$trackSrc}"
			class="{normalize-space(concat('audio ', $sizeClass, ' audio', position(), ' audioContainer ', $recordingClass, ' ', $audioClassExtra, ' ',$autoOpen))}"
		>
			<xsl:if test="@autoScroll"><xsl:attribute name="data-autoscroll"><xsl:value-of select="@autoScroll"/></xsl:attribute></xsl:if>
			<xsl:if test="@autoCC"><xsl:attribute name="data-autocc"><xsl:value-of select="@autoCC"/></xsl:attribute></xsl:if>
			<xsl:if test="@openCC and $noPrecedingOpenCC='y'"><xsl:attribute name="data-opencc">y</xsl:attribute></xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			<div id="audioPlayer_{$apID}"
				class="audioPlayer"
				data-audiosrc="{$trackSrc}" data-lookforID="{$subID}"
				data-size="{$sizeClass}"
				>
			</div>

			<div id="audioPlayerInterface_{$apID}" class="audioInterface">
				<xsl:if test="@a11yTitle">
					<xsl:attribute name="aria-label"><xsl:value-of select="@a11yTitle"/></xsl:attribute>
				</xsl:if>

				<xsl:if test="@a11yTitleLang">
					<xsl:attribute name="lang"><xsl:value-of select="@a11yTitleLang" /></xsl:attribute>
				</xsl:if>

				<audio class="audioPlayer" crossorigin="" playsinline=""/>

				<!-- recording -->
				<xsl:if test="$hasRecordingOption='y'">
					<!-- call the named template 'outputFullRecordingHtml' (in the inc_rcf_recording.xsl file) -->
					<xsl:variable name="audioId">recording_<xsl:value-of select="count(preceding::audio)+1"/></xsl:variable>
					<xsl:call-template name="outputFullRecordingHtml">
						<xsl:with-param name="interactionName" select="'audioRecorder'"/>
						<xsl:with-param name="interactionId" select="$audioId"/>
					</xsl:call-template>
				</xsl:if>

				<!-- output subtitle panels -->
				<xsl:choose>
					<xsl:when test="count(track)>0">
						<xsl:apply-templates select="track" mode="outputSubtitlePanels"/>
					</xsl:when>
					<xsl:when test="@src">
						<xsl:call-template name="outputSubtitlePanel">
							<xsl:with-param name="sourceSubtitleId" select="$subID"/>
							<xsl:with-param name="openStyle" select="$openStyle"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>

			</div>

			<!-- audio script / subtitle element -->
			<xsl:if test="@title">
				<span id="audioTitle_{$apID}" class="audioTitle"><xsl:value-of select="@title"/></span>
			</xsl:if>

			<!-- playlist if available .. no longer used ? -->
			<xsl:if test="count(track)>1">
				<div class="audioPlaylist">
					<input type="checkbox" class="continuousPlay" data-audioplayer="{$apID}" />
					<label for="audioPlayerContinuous_{$apID}">Continuous Play</label>
					<table>
						<tr>
							<th>Track No.</th>
							<th>Track Name</th>
							<th>Page no.</th>
							<th></th>
						</tr>
						<xsl:for-each select="track">
							<xsl:variable name="trackName">
								<xsl:choose>
									<xsl:when test="not(@trackName)">Track : <xsl:value-of select="position()"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@trackName"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<tr class="audioTrack" data-audiosrc="{$audio_path}/{@src}" data-tracknum="{position()-1}">
								<td><xsl:value-of select="position()"/></td>
								<td class="trackName"><xsl:value-of select="$trackName"/></td>
								<td class="trackPageRef"><xsl:value-of select="@pageRef"/></td>
								<td>
									<span class="singleButton audioPlayTrackButton" data-audiosrc="{$audio_path}/{@src}">PLAY</span>
									<span class="singleButton downloadAudioButton" data-audiosrc="{$audio_path}/{@src}">DOWNLOAD</span>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="audio[not(@srt='n')]//track" mode="outputSubtitlePanels">
		<xsl:variable name="noPrecedingOpenCC">
			<xsl:if test="count(preceding::parent[@openCC='y']) = 0 and ancestor::audio/@openCC='y'">y</xsl:if>
		</xsl:variable>

		<xsl:variable name="openStyle">
			<xsl:if test="$noPrecedingOpenCC = 'y'">display: block;</xsl:if>
		</xsl:variable>
		<!-- srt subtitle id should be the src filename without '.mp3' -->
		<xsl:variable name="sourceSubtitleId">
			<xsl:call-template name="stringreplace">
				<xsl:with-param name="stringvalue" select="@src"/>
				<xsl:with-param name="from" select="'.mp3'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="outputSubtitlePanel">
			<xsl:with-param name="sourceSubtitleId" select="$sourceSubtitleId"/>
			<xsl:with-param name="openStyle" select="$openStyle"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="outputSubtitlePanel">
		<xsl:param name="sourceSubtitleId"/>
		<xsl:param name="openStyle"/>

		<div class="audioScript popupPanel" data-audioSrc="{$sourceSubtitleId}" style="{$openStyle}">
			<xsl:if test="ancestor::audio/@lang">
				<xsl:attribute name="lang"><xsl:value-of select="ancestor::audio/@lang"/></xsl:attribute>
			</xsl:if>
			<div class="scriptScroller">
				<div class="script"></div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="audio[not(@size) or @size='large']" mode="getUnmarkedInteractionName">
        rcfAudioPlayerLarge <xsl:if test="$alwaysAddRecordingButton='y' or @recording='y'"> rcfAudioRecorder </xsl:if>
	</xsl:template>

	<xsl:template match="audio[@size='small']" mode="getUnmarkedInteractionName">
		rcfAudioPlayerSmall <xsl:if test="$alwaysAddRecordingButton='y' or @recording='y'"> rcfAudioRecorder </xsl:if>
	</xsl:template>

</xsl:stylesheet>
