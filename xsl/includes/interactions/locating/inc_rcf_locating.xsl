<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- create the HTML for the 'locating' interactive -->
	<xsl:template match="locating">
		<xsl:variable name="locatingPopupId">locatingPopup_<xsl:value-of select="ancestor::activity/@id"/>_<xsl:value-of select="count(preceding::locating)+1"/></xsl:variable>
		<xsl:variable name="rippleClass">
			<xsl:if test="not(ancestor::activity/@rippleButtons='n') and ($alwaysUseRippleButtons='y') or (ancestor::activity/@rippleButtons='y')">rcfRippleButton</xsl:if>
		</xsl:variable>

		<xsl:variable name="locatingType">
			<xsl:choose>
				<xsl:when test="count(dropDown)>0">list</xsl:when>
				<xsl:when test="count(typein)>0">typein</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="answeredClass"><xsl:if test="@example='y'">answered</xsl:if></xsl:variable>
		<xsl:variable name="distractorClass"><xsl:if test="@distractor='y'">distractor</xsl:if></xsl:variable>

		<span class="locating dev-markable-container {$exampleClass} {$distractorClass}" data-rcfinteraction="locating" data-rcfid="{@id}" data-type="{$locatingType}">
			<xsl:if test="not(@example='y')">
				<xsl:if test="count(dropDown)>0">
					<span data-locatingid="{@id}" class="locating_popup dropDown " >
						<xsl:for-each select="dropDown/item">
							<span class="locatingSpanPopup" data-rcfid="{@id}">
								<xsl:apply-templates/>
							</span>
						</xsl:for-each>
						<span class="locatingSpanPopup clear" data-rcfid="-99" data-rcfTranslate="">[ components.label.clear ]</span>
					</span>
				</xsl:if>
				<xsl:if test="count(typein)>0">
					<span data-locatingid="{@id}" class="locating_popup typein" >
						<span class="locating_typein_container">
							<input data-rcfid="{typein/@id}" type="text"
								autocomplete="off" autocapitalize="off" spellcheck="false" autocorrect="off"
								class="locatingText text"
							>
								<xsl:if test="@example='y'"><xsl:attribute name="readonly"/><xsl:attribute name="value"><xsl:value-of select="normalize-space(acceptable/item[1])"/></xsl:attribute></xsl:if>
							</input>
							<span class="textControls">
								<a class="okButton singleButton {$rippleClass}">
									<span data-rcfTranslate="">[ components.button.ok ]</span>
								</a>
								<a class="cancelButton singleButton {$rippleClass}" >
									<span data-rcfTranslate="">[ components.button.cancel ]</span>
								</a>
							</span>
						</span>
					</span>
				</xsl:if>
			</xsl:if>

			<span class="{normalize-space(concat('locatingItem ', $answeredClass, ' ', $exampleClass))}" >
				<span class="item"><xsl:apply-templates select="text()" /></span>
			</span>

			<span class="markable">
				<span class="locating_answer {$exampleClass}">
					<xsl:choose>
						<xsl:when test="$locatingType='list' and @example='y'"><xsl:call-template name="outputLocatingAnswer"><xsl:with-param name="answer" select="normalize-space(dropDown/item[@correct='y']/text())"/></xsl:call-template></xsl:when>
						<xsl:when test="$locatingType='typein' and @example='y'"><xsl:call-template name="outputLocatingAnswer"><xsl:with-param name="answer" select="normalize-space(typein/acceptable/item[1]/text())"/></xsl:call-template></xsl:when>
					</xsl:choose>
				</span>

				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</span>
		</span>
	</xsl:template>

	<xsl:template name="outputLocatingAnswer">
		<xsl:param name="answer" select="''"/>
		<xsl:text> </xsl:text><span class="locatingAnswerBracket leftBracket">(</span><span class="contentLocatingAnswer"><xsl:value-of select="$answer"/></span><span class="locatingAnswerBracket rightBracket">)</span>
	</xsl:template>

	<!-- create the HTML for the locating / dropDown interactive -->
	<xsl:template match="locating/dropDown" />

	<!-- create the HTML for the locating / typeIn interactive -->
	<xsl:template match="locating/typein" />

	<!-- ignore any text elements inside 'locating' -->
	<xsl:template match="locating/text()"><xsl:copy-of select="normalize-space(.)"/></xsl:template>

	<!-- rcf_locating -->
	<xsl:template match="locating" mode="getRcfClassName">
		rcfLocating
	</xsl:template>

</xsl:stylesheet>
