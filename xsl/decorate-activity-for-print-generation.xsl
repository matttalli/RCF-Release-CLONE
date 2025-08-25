<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
>
<!--
	pre-process-activity.xml

	Takes the activity xml and pre-processes it, adding a 'isInteraction="y"' attribute to the following interactions:

	- <dropDown>
	- <typein>
	- <droppable>
	- <interactiveTextBlock type='selectable/selectableWords'/>
	- <radio>
	- <checkbox>
	- <writing>
	- <recording>
	- <matching>
	- <ordering>
	- <complexCategorise>
	- <mathsAddition>
	- <mathsSubtraction>
	- <mathsMultiplication>
	- <mathsDivision>
	- <freeDrawing>


	The *create print* xslt will then use this 'isInteraction="y"' attribute to calculate the correct 'index' number to output
	in the answer key for the print html.

	eg:

	<xsl:template match="droppable" mode="answerKey">
		<xsl:variable name="calculatedId">interaction-<xsl:value-of select="count(preceding::*[@interaction='y'])+1" /></xsl:variable>
		<section>
			<h4><xsl:value-of select="$calculatedId"/></h4>
			<span><xsl:value-of select="."/></span>
		</section>
		<xsl:apply-templates mode="answerKey"/>
	</xsl:template>

-->
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:include href="./includes/scoreAndGradeCalculation/inc_rcf_scoring_variables.xsl"/>

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzñáéíóúü'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÑÁÉÍÓÚÜ'" />

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="activity">
		<!-- get the gradable type and points available for this activity - save time later on -->
		<xsl:variable name="gradableType"><xsl:call-template name="getActivityGradableType"><xsl:with-param name="activityNode" select="."/></xsl:call-template></xsl:variable>
		<xsl:variable name="pointsAvailable"><xsl:call-template name="getActivityPointsForGradableType"><xsl:with-param name="activityNode" select="."/><xsl:with-param name="gradableType" select="$gradableType"/></xsl:call-template></xsl:variable>
		<xsl:variable name="teacherPointsAvailable"><xsl:call-template name="teacherPointsAvailable"><xsl:with-param name="activityNode" select="."/></xsl:call-template></xsl:variable>

		<!-- add a pre-processed="y" attribute to validate in the create print xslt -->
		<xsl:element name="activity">
			<xsl:attribute name="preProcessed">y</xsl:attribute>
			<xsl:attribute name="gradableType"><xsl:value-of select="$gradableType"/></xsl:attribute>
			<xsl:attribute name="pointsAvailable"><xsl:value-of select="$pointsAvailable + $teacherPointsAvailable"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!--
		for 'list' style interactions, decorate them a bit further

		so
			<dropDown> will become <dropDown isInteraction="y" printClass="rcfPrint-dropdown" printType="inline">
			<radio> will become <radio isInteraction="y" printClass="rcfPrint-radio" printType="list">
			etc
	-->
	<xsl:template match="checkbox | dropDown | radio">
		<xsl:variable name="printClass">
			<xsl:value-of select="translate(local-name(.), $uppercase, $lowercase)"/>
		</xsl:variable>

		<xsl:variable name="printType">
			<xsl:choose>
				<xsl:when test="local-name(.)='dropDown'">inline</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-<xsl:value-of select="$printClass"/></xsl:attribute>
			<xsl:attribute name="printType"><xsl:value-of select="$printType"/></xsl:attribute>

			<!-- treat interaction as example when all items are @example='y' -->
			<xsl:if test="count(./item) = count(./item[@example='y']) and count(./item) > 0">
				<xsl:attribute name="example">y</xsl:attribute>
			</xsl:if>

			<!-- copy original attributes -->
			<xsl:apply-templates select="@*"/>

			<!--
				randomze the 'item' elements inside this interaction in the generated decorated xml

				This *will not* be in the same order as the on-screen activity - that won't happen without the javascript code

			-->
			<xsl:variable name="randomizeItemsInOutput"><xsl:if test="ancestor::activity/@randomizeItems='fixed' or ancestor::activity/@randomizeItems='always'">y</xsl:if></xsl:variable>

			<xsl:choose>
				<xsl:when test="ancestor::activity/@sortItemsAlphabetically='y'">
					<xsl:apply-templates select="." mode="sortItemsAlphabetically"/>
				</xsl:when>
				<xsl:when test="$randomizeItemsInOutput='y'">
					<xsl:apply-templates select="." mode="randomizeItems"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- just copy over the items / attributes -->
					<xsl:apply-templates select="@*|node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>

	</xsl:template>

	<xsl:template match="complexDroppableBlock">
		<xsl:element name="complexDroppableBlock">
			<xsl:attribute name="longestItem">
				<xsl:call-template name="pick-longest-item">
					<xsl:with-param name="items" select="complexDroppables/item"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:apply-templates select="@*"/>
			<wordList>
				<!-- choose whether to sort alphabetically or randomly -->
				<xsl:choose>
					<xsl:when test="ancestor::activity/@sortItemsAlphabetically='y'">
						<xsl:apply-templates select="." mode="sortItemsAlphabetically"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="randomizeItems"/>
					</xsl:otherwise>
				</xsl:choose>
			</wordList>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="typein | droppable | complexDroppable">
		<xsl:variable name="printClass">
			<xsl:value-of select="translate(local-name(.), $uppercase, $lowercase)"/>
		</xsl:variable>
		<xsl:variable name="printType">gapfill-<xsl:value-of select="local-name(.)"/></xsl:variable>

		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-<xsl:value-of select="$printClass"/></xsl:attribute>
			<xsl:attribute name="printType"><xsl:value-of select="$printType"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="ordering">
		<xsl:variable name="printClass">ordering</xsl:variable>
		<xsl:element name="ordering">
			<!-- add new attributes -->
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-<xsl:value-of select="$printClass"/></xsl:attribute>
			<xsl:attribute name="printType">list</xsl:attribute>
			<!-- copy original attributes -->
			<xsl:apply-templates select="@*"/>

			<!-- apply child templates (item and suffix) -->
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="ordering/item">
		<xsl:element name="item">
			<!-- Add order attribute to ordering items to allow easier example and answer key output -->
			<xsl:attribute name="order"><xsl:value-of select="count(preceding-sibling::*)+1"/></xsl:attribute>
			<!-- copy original attributes -->
			<xsl:apply-templates select="@*"/>
			<!-- copy content of original element -->
			<xsl:copy-of select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexCategorise">

		<xsl:variable name="printType">gapfill-<xsl:value-of select="local-name(.)"/></xsl:variable>

		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-complex-categorise</xsl:attribute>
			<xsl:attribute name="printType"><xsl:value-of select="$printType"/></xsl:attribute>
			<!-- copy existing attributes -->
			<xsl:apply-templates select="@*"/>

			<!-- output the categorise items -->
			<xsl:variable name="randomizeItemsInOutput"><xsl:if test="ancestor::activity/@randomizeItems='fixed' or ancestor::activity/@randomizeItems='always'">y</xsl:if></xsl:variable>

			<xsl:choose>
				<xsl:when test="ancestor::activity/@sortItemsAlphabetically='y'">
					<xsl:apply-templates select="." mode="sortItemsAlphabetically"/>
				</xsl:when>
				<xsl:when test="$randomizeItemsInOutput='y'">
					<xsl:apply-templates select="." mode="randomizeItems"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- just copy over the items / attributes -->
					<xsl:apply-templates select="@*|node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template match="checkbox | dropDown | radio" mode="sortItemsAlphabetically">
		<xsl:for-each select="item">
			<xsl:sort select="translate(text(), $lowercase, $uppercase)"/>
			<item id="{@id}" order="{position()}">
				<xsl:if test="@correct">
					<xsl:attribute name="correct"><xsl:value-of select="@correct"/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates/>
			</item>
		</xsl:for-each>
	</xsl:template>

	<!--
		checkbox, dropDown, radio and ordering interactions all contain simple child 'item' elements
		- so they can be randomized using a single template here
	-->
	<xsl:template match="checkbox | dropDown | radio | ordering" mode="randomizeItems">
		<!-- get a default seed of the node position in the xml -->
		<xsl:variable name="defaultSeed"><xsl:value-of select="count(preceding::*)"/></xsl:variable>
		<!-- calculate the print seed to use -->
		<xsl:variable name="printSeed">
			<xsl:choose>
				<xsl:when test="ancestor::activity/@printSeed"><xsl:value-of select="$defaultSeed + ancestor::activity/@printSeed"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(item) * $defaultSeed"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- output the item elements -->
		<xsl:call-template name="pick-random-item">
			<xsl:with-param name="items" select="item"/>
			<!-- seed has to be big ... in the 1000s so that a single digit change, makes a big difference -->
			<xsl:with-param name="seed" select="$printSeed * 4096"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="complexDroppableBlock" mode="sortItemsAlphabetically">
		<xsl:for-each select="complexDroppables/item">
			<xsl:sort select="translate(text(), $lowercase, $uppercase)"/>
			<item id="{@id}" order="{position()}">
				<xsl:copy-of select="node()"/>
			</item>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="complexDroppableBlock" mode="randomizeItems">
		<!-- decide on a seed value -->
		<xsl:variable name="printSeed">
			<xsl:choose>
				<xsl:when test="ancestor::activity/@printSeed"><xsl:value-of select="count(preceding::*) + ancestor::activity/@printSeed"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(preceding::*) + count(complexDroppables/item)*22"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="pick-random-item">
			<xsl:with-param name="items" select="complexDroppables/item"/>
			<!-- seed has to be big ... in the 1000s so that a single digit change, makes a big difference -->
			<xsl:with-param name="seed" select="$printSeed * 4096"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="complexCategorise" mode="sortItemsAlphabetically">
		<xsl:element name="items">
			<xsl:for-each select="items/item">
				<xsl:sort select="translate(text(), $lowercase, $uppercase)"/>
				<xsl:variable name="itemId" select="@id"/>
				<item id="{@id}" order="{position()}">
					<xsl:if test="count(ancestor::complexCategorise//categories//item[@id=$itemId and @example='y']) > 0">
						<xsl:attribute name="example">y</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</item>
			</xsl:for-each>
		</xsl:element>
		<xsl:apply-templates select="categories"/>
	</xsl:template>

	<xsl:template match="complexCategorise" mode="randomizeItems">
		<!-- get a default seed of the node position in the xml -->
		<xsl:variable name="defaultSeed"><xsl:value-of select="count(preceding::*)"/></xsl:variable>
		<!-- calculate the print seed to use -->
		<xsl:variable name="printSeed">
			<xsl:choose>
				<xsl:when test="ancestor::activity/@printSeed"><xsl:value-of select="$defaultSeed + ancestor::activity/@printSeed"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(items/item) * $defaultSeed"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="items">
			<!-- output the item elements -->
			<xsl:call-template name="pick-random-item">
				<xsl:with-param name="items" select="items/item"/>
				<!-- seed has to be big ... in the 1000s so that a single digit change, makes a big difference -->
				<xsl:with-param name="seed" select="$printSeed * 4096"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:apply-templates select="categories"/>

	</xsl:template>

	<xsl:template match="mathsAddition">
		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-mathsaddition</xsl:attribute>
			<xsl:attribute name="printType">list</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mathsSubtraction">
		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-mathssubtraction</xsl:attribute>
			<xsl:attribute name="printType">list</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mathsMultiplication">
		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-mathsmultiplication</xsl:attribute>
			<xsl:attribute name="printType">list</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mathsDivision">
		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-mathsdivision</xsl:attribute>
			<xsl:attribute name="printType">list</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="pick-random-item">
		<!-- the items to be randomized - will be changed on each recursive call -->
		<xsl:param name="items" />
		<!-- the original node list - used (unmodified) on each call so we can determine the original order -->
		<xsl:param name="originalItems" select="$items"/>
		<!-- the seed to use for randomization - if not provided to the named template, uses the length of the node list * 256 as... I made it up :) -->
		<xsl:param name="seed" select="count($originalItems)*256"/>

		<!-- if there are any items to output -->
		<xsl:if test="$items">
			<!-- generate a random number using the "linear congruential generator" algorithm -->
			<xsl:variable name="a" select="1664525"/>
			<xsl:variable name="c" select="1013904223"/>
			<xsl:variable name="m" select="4294967296"/>
			<xsl:variable name="random" select="($a * $seed + $c) mod $m"/>
			<!-- scale random to integer 1..n -->
			<xsl:variable name="i" select="floor($random div $m * count($items)) + 1"/>

			<!-- get the id of the item being output -->
			<xsl:variable name="itemId" select="$items[$i]/@id"/>

			<!-- output the element name for the item being randomized / shuffled -->
			<xsl:element name="{local-name($items[$i])}" >
				<!-- create a new 'order' attribute -->
				<xsl:attribute name="order"><xsl:value-of select="count($originalItems[@id=$itemId]/preceding-sibling::*)+1"/></xsl:attribute>
				<!-- copy the attributes from the original item -->
				<xsl:apply-templates select="$items[$i]/@*"/>
				<!-- copy the children from the original item -->
				<xsl:copy-of select="$items[$i]/node()"/>
			</xsl:element>

			<!-- recursive call with the remaining items -->
			<xsl:call-template name="pick-random-item">
				<xsl:with-param name="items" select="$items[position()!=$i]"/>
				<xsl:with-param name="originalItems" select="$originalItems"/>
				<xsl:with-param name="seed" select="$random"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="pick-longest-item">
		<xsl:param name="items" />
		<xsl:for-each select="$items">
			<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
			<xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="
		interactiveTextBlock[@type='selectable' or @type='selectableWords'] |
		writing |
		recording |
		matching |
		freeDrawing">

		<xsl:element name="{local-name(.)}">
			<xsl:attribute name="isInteraction">y</xsl:attribute>
			<xsl:attribute name="printClass">rcfPrint-<xsl:value-of select="translate(local-name(.), $uppercase, $lowercase)"/></xsl:attribute>
			<xsl:attribute name="printType">inline</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- list of things to ignore, not include in the decorated xml -->
	<xsl:template match="list/@collapsible"/>

</xsl:stylesheet>
