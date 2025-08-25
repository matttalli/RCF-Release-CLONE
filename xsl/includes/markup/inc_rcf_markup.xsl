<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:key name="catKey" match="cats" use="cat/@id"/>
	<!-- Output 'ediv' and 'eSpan' - they are exactly the same thing really -->

	<xsl:include href="./list/inc_rcf_list.xsl"/>
	<xsl:include href="./prompt/inc_rcf_prompt.xsl"/>
	<xsl:include href="./feedback/inc_rcf_feedback.xsl"/>
	<xsl:include href="./images/inc_rcf_image_elements.xsl"/>

	<xsl:template match="eDiv | eSpan">
		<xsl:variable name="parentIsExample"><xsl:if test="ancestor::interactiveTextBlock/@example='y' or ancestor::itemSelectableText/@example='y'">y</xsl:if></xsl:variable>
		<xsl:variable name="itType">
			<xsl:choose>
				<xsl:when test="ancestor::interactiveTextBlock"><xsl:value-of select="ancestor::interactiveTextBlock/@type"/></xsl:when>
				<xsl:when test="ancestor::itemSelectableText">selectable</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="ancestor::interactiveTextBlock"><xsl:value-of select="ancestor::interactiveTextBlock/@mark"/></xsl:when>
				<xsl:when test="ancestor::itemSelectableText"><xsl:value-of select="ancestor::itemSelectableText/@mark"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="elemName"><xsl:value-of select="name()"/></xsl:variable>
		<xsl:variable name="userClassName"><xsl:value-of select="@class"/> </xsl:variable>
		<xsl:variable name="element">
			<xsl:choose>
				<xsl:when test="$elemName='eDiv'">div</xsl:when>
				<xsl:when test="$elemName='eSpan'">span</xsl:when>
				<xsl:otherwise>span</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="elementId">
			<xsl:choose>
				<xsl:when test="$elemName='eDiv'">eDiv-<xsl:value-of select="count(preceding::eDiv)"/></xsl:when>
				<xsl:when test="$elemName='eSpan'">eSpan-<xsl:value-of select="count(preceding::eSpan)"/></xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isMarkable">
			<xsl:choose>
				<xsl:when test="$itType='toggle'">N</xsl:when>
				<xsl:when test="$itType='selectable'">Y</xsl:when>
				<xsl:when test="$itType='selectableWords'">Y</xsl:when>
				<xsl:when test="$itType='selectableCat'">Y</xsl:when>
				<xsl:when test="$itType='selectableCatWords'">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y' or (@correct='y' and $parentIsExample='y') or (@cat and $parentIsExample='y') ">example</xsl:if></xsl:variable>
		<xsl:variable name="devMarkContainerClass"><xsl:if test="($markType='item' or $markType='')">dev-markable-container</xsl:if></xsl:variable>
		<xsl:variable name="className">
			<xsl:choose>
				<xsl:when test="$itType='show'"> hidden </xsl:when>
				<xsl:when test="$itType='toggle'"> toggle </xsl:when>
				<xsl:when test="$itType='selectableWords'"> selectable markable </xsl:when>
				<xsl:when test="$itType='selectable'"> selectable markable </xsl:when>
				<xsl:when test="$itType='selectableCat'"> selectableCat markable </xsl:when>
				<xsl:when test="$itType='selectableCatWords'"> selectableCat markable </xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="{$element}">
			<xsl:attribute name="data-rcfid"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:variable name="catID"><xsl:value-of select="@cat"/></xsl:variable>
			<xsl:variable name="catNode" select="ancestor::interactiveTextBlock/cats/cat[@id=$catID]"/>
			<xsl:variable name="catNum" select="count($catNode | $catNode/preceding-sibling::cat)"/>

			<xsl:variable name="distractorClass"><xsl:if test="@distractor='y' or not(@correct='y') and not(@cat)"> distractor </xsl:if></xsl:variable>
			<xsl:variable name="answeredClass"><xsl:if test="@example='y' or (@correct='y' and $parentIsExample='y') or (@cat and $parentIsExample='y')"> answered </xsl:if></xsl:variable>
			<xsl:variable name="toggleStateClass"><xsl:if test="@toggleStates">toggleState1</xsl:if></xsl:variable>

			<xsl:attribute name="class"><xsl:value-of select="normalize-space(concat($elemName, ' cat_', $catNum, ' ', $className, ' ', $userClassName, ' ', $exampleClass, ' ', $answeredClass, ' ', $toggleStateClass, ' ', $distractorClass, ' ', $devMarkContainerClass))"/></xsl:attribute>

			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::interactiveTextBlock[not(@type='selectableCat') and not(@type='selectableCatWords')]">
				<xsl:attribute name="data-cat"><xsl:value-of select="@cat"/></xsl:attribute>
 				<xsl:attribute name="data-catIndex"><xsl:value-of select="count($catNode | $catNode/preceding-sibling::cat)"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::interactiveTextBlock/@type='toggle'">
				<xsl:variable name="toggleValue">
					<xsl:choose>
						<xsl:when test="@toggleStates"><xsl:value-of select="@toggleStates"/></xsl:when>
						<xsl:otherwise>2</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="data-toggleStates"><xsl:value-of select="$toggleValue"/></xsl:attribute>
			</xsl:if>

			<xsl:variable name="selectedClass"><xsl:if test="@example='y' or (@correct='y' and $parentIsExample='y') or (@cat and $parentIsExample='y')"><xsl:text> </xsl:text>selected<xsl:text> </xsl:text></xsl:if></xsl:variable>
			<xsl:choose>
				<xsl:when test="$itType='selectableWords' or $itType='selectable'">
					<xsl:element name="{$element}">
						<xsl:attribute name="class">selectable <xsl:value-of select="$exampleClass"/> <xsl:value-of select="$selectedClass"/></xsl:attribute>
						<xsl:apply-templates/>
					</xsl:element>
					<xsl:if test="$isMarkable='Y'">
						<!-- RCF-295 -->
						<xsl:choose>
							<xsl:when test="$markType='item' or $markType=''">
								<span class="selectableMarkContainer" data-rcfid="{@id}_markContainer">
									<span class="mark">&#160;&#160;&#160;&#160;</span>
								</span>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:when>

				<xsl:when test="$itType='selectableCat' or $itType='selectableCatWords'">
					<xsl:element name="{$element}">
						<xsl:attribute name="class">selectableCat <xsl:value-of select="$exampleClass"/></xsl:attribute>
						<xsl:attribute name="data-cat"><xsl:value-of select="@cat"/></xsl:attribute>
						<xsl:attribute name="id">selectableCat_<xsl:value-of select="$elementId"/></xsl:attribute>
						<span id="selectable_{$elementId}" class="selectableCatItem">
							<xsl:apply-templates/>
						</span>
						<span class="markable">
							<span class="answer">
								<xsl:if test="@example='y' or (@correct='y' and $parentIsExample='y') or (@cat and $parentIsExample='y')">
									<xsl:attribute name="style">display:inline;</xsl:attribute>
									<xsl:variable name="exampleCat" select="@cat"/>
									(<xsl:value-of select="ancestor::interactiveTextBlock/cats/cat[@id=$exampleCat]"/>)
								</xsl:if>
							</span>
							<!-- RCF-295 -->
							<span class="selectableMarkContainer" data-rcfid="{@id}_markContainer">
								<span class="mark">&#160;&#160;&#160;&#160;</span>
							</span>
						</span>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<!-- styled span, complex styled span and typeInGroup span -->
	<xsl:template match="sSpan | cSpan | tSpan">
		<span class="{name()} {@class}" id="{@id}">
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
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!-- colourText -->
	<xsl:template match="colourText">
		<xsl:if test="normalize-space(.)!=''">
		<mark class="colourText">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</mark>
	</xsl:if>
	</xsl:template>

	<!-- dl -->
	<xsl:template match="dl">
		<xsl:if test="normalize-space(.)!=''">
		<dl class="{@class}">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</dl>
		</xsl:if>
	</xsl:template>

	<!-- dt -->
	<xsl:template match="dt">
		<dt class="{@class}">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<!-- dd -->
	<xsl:template match="dd">
		<dd class="{@class}">
			<xsl:if test="@lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<!-- all of these elements are basically HTML mapped with no attributes - hence the simple template -->
	<xsl:template match="h1 | h2 | h3 | h4 | h5 | h6 | b | i | sup | sub | table | th | td | p | tr | br">
		<xsl:variable name="extraClass">
			<xsl:choose>
				<xsl:when test="name()='th' or name()='td'"><xsl:if test="position()=1"> leftCell</xsl:if></xsl:when>
				<xsl:when test="name()='tr'"><xsl:choose><xsl:when test="count(th)>0 and (position()=1)"></xsl:when><xsl:when test="(position()+1) mod 2 = 0"> even</xsl:when><xsl:otherwise> odd</xsl:otherwise></xsl:choose></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{name()}">
			<xsl:if test="name()='td' or name()='th'">
				<xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
				<xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute></xsl:if>
			</xsl:if>
			<xsl:if test="count(@class)>0 or $extraClass!=''">
				<xsl:attribute name="class"><xsl:value-of select="@class"/> <xsl:value-of select="$extraClass"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="name()='p' and @lang">
				<xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- RCF-217 -->
	<xsl:template match="u"><span class="underline"><xsl:apply-templates/></span></xsl:template>

	<!-- strike through -->
	<xsl:template match="strike">
		<del>
			<xsl:apply-templates />
		</del>
	</xsl:template>

	<!-- RCF-11108 -->
	<xsl:template match="phons">
		<span data-rcfTranslate="" aria-label="[ components.markup.phons.label ]" role="text" lang="en-fonipa" class="{normalize-space(concat('phons ', @class))}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!-- hyperlink -->
	<xsl:template match="a">
		<xsl:variable name="href">
			<xsl:choose>
				<xsl:when test="@levelAssetLink='y'"><xsl:value-of select="$levelAssetsURL"/>/<xsl:value-of select="@href"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a rel="external" href="{$href}" target="_blank">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<!-- handling for paragraph and list text() elements -->
	<xsl:template match="p/text() | li/text() | td/text() | th/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text() | checkbox/item/text() | radio/item/text() | category/item/text() | clue/text() | u/text()">
		<xsl:choose>
			<xsl:when test=".=' '"><xsl:text> </xsl:text></xsl:when>
			<xsl:when test="not($authoring='Y')"><xsl:value-of select="."/></xsl:when>
			<xsl:when test="normalize-space(.)!=''"><span class="rcfText"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute><xsl:copy-of select="."/></span></xsl:when>
			<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="interactiveTextBlock[@type='selectableWords']//text()[not(ancestor::eSpan)]" name="tokenizeSelectableWords">
		<xsl:param name="text" select="."/>
		<xsl:param name="separator" select="' '"/>
		<xsl:param name="intID" select="'1'"/>

		<xsl:variable name="markType">
			<xsl:value-of select="ancestor::interactiveTextBlock/@mark"/>
		</xsl:variable>

		<xsl:variable name="devMarkContainerClass"><xsl:if test="($markType='item' or $markType='')">dev-markable-container</xsl:if></xsl:variable>

		<!-- if the original string ended with a space, it would get 'normalized' and passed in - just ignore these 'empty' calls to the tokenizer -->
		<xsl:if test="not($text='')">
			<xsl:variable name="useID">
				<xsl:value-of select="ancestor::interactiveTextBlock/@id"/>_<xsl:value-of select="count(preceding::text())+1"/>_<xsl:value-of select="$intID"/>
			</xsl:variable>
			<xsl:variable name="outputText">
				<xsl:choose>
					<xsl:when test="not(contains($text, $separator))"><xsl:value-of select="normalize-space($text)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="normalize-space(substring-before($text, $separator))"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="string-length($outputText) &gt; 0">
				<span data-rcfid="{$useID}" class="{normalize-space(concat('eSpan selectable markable distractor ', $devMarkContainerClass))}">
					<span id="selectable_{$useID}" class="selectable distractor"><xsl:value-of select="$outputText"/></span>
					<xsl:if test="ancestor::interactiveTextBlock[@mark='item'] or not(ancestor::interactiveTextBlock[@mark])">
						<span class="mark">&#160;&#160;&#160;&#160;</span>
					</xsl:if>
				</span><xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string-length($outputText) = 0">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($text, $separator) and $text!=$separator">
				<xsl:call-template name="tokenizeSelectableWords">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="intID" select="$intID+1"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="interactiveTextBlock[@type='selectableCatWords']//text()[not(ancestor::eSpan)]" name="tokenizeSelectableCatWords">
		<xsl:param name="text" select="."/>
		<xsl:param name="separator" select="' '"/>
		<xsl:param name="intID" select="'1'"/>

		<!-- if the original string ended with a space, it would get 'normalized' and passed in - just ignore these 'empty' calls to the tokenizer -->
		<xsl:if test="not($text='')">
			<xsl:variable name="useID">
				<xsl:value-of select="ancestor::interactiveTextBlock/@id"/>_<xsl:value-of select="count(preceding::text())+1"/>_<xsl:value-of select="$intID"/>
			</xsl:variable>
			<xsl:variable name="outputText">
				<xsl:choose>
					<xsl:when test="not(contains($text, $separator))"><xsl:value-of select="normalize-space($text)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="normalize-space(substring-before($text, $separator))"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="string-length($outputText) &gt; 0">
				<span data-rcfid="{$useID}" class="eSpan selectableCat dev-markable-container distractor">
					<span id="selectableCatItem_{$useID}" class="selectableCatItem"><xsl:value-of select="$outputText"/></span>
					<span class="markable">
						<span class="answer"></span>
						<span class="mark">&#160;&#160;&#160;&#160;</span>
					</span>
				</span><xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string-length($outputText) = 0">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($text, $separator) and $text!=$separator">
				<xsl:call-template name="tokenizeSelectableCatWords">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="intID" select="$intID+1"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- create the HTML for the 'popupLink' interactive -->
	<xsl:template match="popupLink">
		<xsl:variable name="pl_number"><xsl:value-of select="count(preceding-sibling::popupLink)"/></xsl:variable>
		<a href="javascript:;"
			data-infoblockid="{@infoBlockID}"
			id="popupLink_{@infoBlockID}"
			class="popupLink pos_{$pl_number}">
			<xsl:apply-templates />
		</a>
	</xsl:template>

	<!-- default text output handling -->
	<xsl:template match="text()">
		<!-- remember, this will output *ANY* text nodes, eg

			<metadata><ref>STUFF !</ref></metadata>

			- if it is caught by the template loop - so you must handle every template in this
			  situation !
		-->
		<!-- <xsl:choose>
			<xsl:when test="$authoring='Y' and count(ancestor::catName)=0 and count(ancestor::locating/dropDown)=0 and count(ancestor::droppable)=0 and count(ancestor::matching)=0 and string-length(normalize-space(.)) &gt; 0">
				<span class="rcfText"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute><xsl:copy-of select="normalize-space(.)"/></span>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
		</xsl:choose> -->
		<xsl:copy-of select="."/>
	</xsl:template>

</xsl:stylesheet>
