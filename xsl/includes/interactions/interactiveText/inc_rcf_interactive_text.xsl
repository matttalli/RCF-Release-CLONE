<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- interactive text templates - interactiveTextBlock -->
	<xsl:template match="interactiveTextBlock">
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="devMarkableClass"><xsl:if test="@mark='list'">dev-markable-container</xsl:if></xsl:variable>

		<div data-rcfid="{@id}"
			data-rcfinteraction="interactiveText"
			class="{normalize-space(concat('interactiveText type_', @type, ' ', @class, ' ', $exampleClass, ' ', $devMarkableClass))}"
			data-interactivetexttype="{@type}"
			data-marktype="{@mark}"
		>
			<xsl:if test="@restrict='y'">
				<xsl:attribute name="data-rcfrestrict"><xsl:value-of select="count(.//*[@correct='y' and not(@example='y') ])"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="(@type='selectableCat' or @type='selectableCatWords') and not(@example='y')">
				<xsl:attribute name="data-cats"><xsl:for-each select="cats/cat"><xsl:value-of select="@id"/><xsl:if test="position()!=last()">|</xsl:if></xsl:for-each></xsl:attribute>
			</xsl:if>
			<!--
				don't output a popup html fragment if this is an example interaction
			-->
			<xsl:apply-templates select="." mode="outputInteractiveTextBlockCategoriesPopup"/>
			<xsl:apply-templates select="." mode="outputInteractiveTextBlockTextControls"/>

			<div class="itMain">
				<xsl:apply-templates/>
				<xsl:if test="@mark='list'">
					<span class="selectableMarkContainer"><span class="mark">&#160;&#160;&#160;&#160;</span></span>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<!-- output the selectCat / selectCatWords popup -->
	<xsl:template match="interactiveTextBlock[not(@example='y') and (@type='selectableCat' or @type='selectableCatWords')]" mode="outputInteractiveTextBlockCategoriesPopup">
		<span class="interactiveText_popup" data-interactivetext-rcfid="{@id}" data-popuptype="list">
			<xsl:for-each select="cats/cat">
				<span class="interactiveTextSpanPopup " data-catid="{@id}" data-catIndex="cat_{position()}">
					<xsl:value-of select="."/>
				</span>
			</xsl:for-each>
			<span class="interactiveTextSpanPopup clear" data-catid="-99" data-rcfTranslate="">[ components.label.clear ]</span>
		</span>
	</xsl:template>

	<!--
		text controls for old-school interaction types

			<xs:enumeration value="show"/>
			<xs:enumeration value="hide"/>
			<xs:enumeration value="blur"/>
			<xs:enumeration value="highlight"/>
	-->
	<xsl:template match="interactiveTextBlock[not(@example='y') and (count(cats)>0) and (@type='show' or @type='hide' or @type='blur' or @type='highlight')]" mode="outputInteractiveTextBlockTextControls">
		<xsl:variable name="catList">
			<xsl:for-each select="cats/cat">
				<xsl:value-of select="@id"/>:<xsl:value-of select="@begin"/><xsl:if test="position()!=last()">|</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="defaultCatID"><xsl:value-of select="@defaultCatID"/></xsl:variable>
		<xsl:variable name="blockControlType"><xsl:value-of select="@controlType"/></xsl:variable>
		<xsl:variable name="buttonExtraClass">
			<xsl:if test="@controlType='toggle'">singleButton</xsl:if>
		</xsl:variable>

		<div class="textControls" >
			<div class="blockControls speedControls"
				data-timed="{@timed}"
				data-cattype="{@type}"
				data-controltype="{@controlType}"
				data-catlist="{$catList}"
			>
				<xsl:if test="@defaultCatID">
					<xsl:attribute name="data-defaultcatid"><xsl:value-of select="@defaultCatID"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@timed='y'">
					<xsl:attribute name="data-begin"><xsl:value-of select="@begin"/></xsl:attribute>
					<xsl:attribute name="data-countdown"><xsl:value-of select="@showCountDown"/></xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@timed='n'">
						<xsl:for-each select="cats/cat">
							<xsl:variable name="buttonClass">
								<xsl:if test="$blockControlType!='toggle'">
									<xsl:choose>
										<xsl:when test="position()=1 and position() &lt; last()">leftButton</xsl:when>
										<xsl:when test="position() &gt; 1 and position() &lt; last()">middleButton</xsl:when>
										<xsl:when test="position()=1 and position()=last()">singleButton</xsl:when>
										<xsl:otherwise>rightButton</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="$defaultCatID=@id"> selected</xsl:if>
							</xsl:variable>
							<a class="{$buttonClass} {$buttonExtraClass}"
								href="javascript:;"
								data-cat="{@id}"
								data-oncaption="{@onCaption}"
								data-offcaption="{@caption}"
							><xsl:value-of select="@caption"/></a>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="@timed='y'">
						<a class="play singleButton" href="javascript:;" data-rcfTranslate="">[ components.button.start ]</a>
						<a class="reset singleButton" href="javascript:;" data-rcfTranslate="">[ components.button.reset ]</a>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="@showCountDown='y'">
					<span class="countDown"></span>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="text()" mode="outputInteractiveTextBlockCategoriesPopup"/>
	<xsl:template match="text()" mode="outputInteractiveTextBlockTextControls"/>

	<!-- rcf_categorise_selectable -->
	<xsl:template match="interactiveTextBlock[@type='selectableCat' or @type='selectableCatWords']" mode="getRcfClassName">
		rcfCategoriseSelectable
		<xsl:apply-templates mode="getRcfClassName"/>
	</xsl:template>

	<!-- rcf_selectable -->
	<xsl:template match="interactiveTextBlock[@type='selectable' or @type='selectableWords']" mode="getRcfClassName">
		rcfSelectableElements
		<xsl:apply-templates mode="getRcfClassName"/>
	</xsl:template>

	<xsl:template match="interactiveTextBlock[not(contains(@type, 'selectable'))]" mode="getUnmarkedInteractionName">
		rcfInteractiveText
		<xsl:apply-templates mode="getUnmarkedInteractionName"/>
	</xsl:template>
</xsl:stylesheet>
