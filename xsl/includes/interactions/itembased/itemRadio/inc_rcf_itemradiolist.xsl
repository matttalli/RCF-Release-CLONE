<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- standard radioList - not item select -->
	<xsl:template match="itemRadio[not(@displayType='itemSelect')]">
		<xsl:variable name="containerClassName">radioItemContainer</xsl:variable>
		<xsl:variable name="orientation">
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
				<xsl:otherwise>horizontal</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="listElementName">
			<xsl:choose>
				<xsl:when test="ancestor::p">span</xsl:when>
				<xsl:when test="@type='numbered' or @type='alpha' or @type='upper-alpha' or @type='roman'">ol</xsl:when>
				<xsl:otherwise>ul</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="listItemElementName">
			<xsl:choose>
				<xsl:when test="ancestor::p">span</xsl:when>
				<xsl:otherwise>li</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="listItemElementClass">
			<xsl:if test="ancestor::p">li</xsl:if>
		</xsl:variable>

		<xsl:variable name="className">
			radioList itemRadioList<xsl:text> </xsl:text>answers<xsl:value-of select="count(item)"/>
			<xsl:if test="@type!=''"><xsl:text> </xsl:text><xsl:value-of select="@type"/></xsl:if>
			<xsl:if test="$orientation!=''"><xsl:text> </xsl:text><xsl:value-of select="$orientation"/></xsl:if>
			<xsl:if test="@example='y'"><xsl:text> </xsl:text>example</xsl:if>
			<xsl:if test="count(.//image) + count(.//imageAudio) > 0"><xsl:text> </xsl:text>hasImageAnswers</xsl:if>
			<xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if>
		</xsl:variable>

		<xsl:element name="{$listElementName}">
			<xsl:attribute name="data-rcfid"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="data-rcfinteraction">radioList</xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="normalize-space($className)"/></xsl:attribute>
			<xsl:if test="not(@example='y') and not(@marked='n') and count(item[@correct='y']) &gt; 0 and not(ancestor::activity/@marked='n')">
				<xsl:attribute name="data-requires-answers">y</xsl:attribute>
			</xsl:if>

			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			<xsl:if test="./@start"><xsl:attribute name="start"><xsl:value-of select="@start"/></xsl:attribute></xsl:if>

			<xsl:if test="./@reversed='y'"><xsl:attribute name="reversed">reversed</xsl:attribute></xsl:if>

			<xsl:for-each select="item">
				<xsl:element name="{$listItemElementName}">
					<xsl:attribute name="class">dev-list-item</xsl:attribute>
					<xsl:variable name="imageAnswerClass"><xsl:if test="count(.//image) + count(.//imageAudio) > 0">imageAnswer</xsl:if></xsl:variable>

					<xsl:variable name="listItemId">
						<xsl:value-of select="ancestor::activity/@id"/>
						_radiolist_<xsl:value-of select="ancestor::itemRadio/@id"/>_listItem_<xsl:value-of select="@id"/>
					</xsl:variable>

					<span class="{normalize-space(concat('markable radio dev-markable-container ', $imageAnswerClass))}">
						<input id="{normalize-space($listItemId)}" type="radio" class="radio" data-rcfid="{@id}" name="radio_{ancestor::activity/@id}_{ancestor::itemRadio/@id}">
							<xsl:if test="@audio"><xsl:attribute name="data-audiolink"><xsl:value-of select="@audio"/></xsl:attribute></xsl:if>
							<xsl:if test="( (../@example='y' and @correct='y') or (@example='y' and @correct='y') )"><xsl:attribute name="checked"/><xsl:attribute name="data-correct">y</xsl:attribute></xsl:if>
						</input>

						<!-- output is different structure for vertical & horizontal lists -->
						<xsl:choose>
							<xsl:when test="@display='h'">
								<!--  add empty 'onClick' because iPad sucks ;-) -->
								<label for="{normalize-space($listItemId)}" onClick="">
									<xsl:apply-templates/>
								</label>
								<span class="mark">&#160;&#160;&#160;&#160;</span>
							</xsl:when>
							<xsl:otherwise>
								<span class="radioItemContainer">
									<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
									<label for="{normalize-space($listItemId)}" onClick="">
										<xsl:apply-templates/>
									</label>
									<span class="markContext">
										<span class="mark">&#160;&#160;&#160;&#160;</span>
									</span>
								</span>
							</xsl:otherwise>
						</xsl:choose>
						<!-- end display differences for vertical / horizontal check/radiolists -->
					</span>
				</xsl:element>
			</xsl:for-each>

		</xsl:element>
	</xsl:template>

	<!-- rcf_itembased_radio -->
	<xsl:template match="itemRadio[not(@displayType='itemSelect')]" mode="getItemBasedRcfClassName">
		rcfItemBasedRadio
	</xsl:template>

</xsl:stylesheet>
