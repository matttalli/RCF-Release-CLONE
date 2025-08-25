<?xml version="1.0" encoding="UTF-8"?>
<!--
	create_interactive_ids.xsl

	@author Chris Eastwood
	@desc 	Adds the 'id' attribute and value to interactive elements (and some non-interactive) in an RCF XML document
			- these ids are used in the eventual json answers object which is passed to the DevBliss system

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xslt="http://xml.apache.org/xslt"
	version="1.0">

	<xsl:output method="xml" indent="yes" xslt:indent-amount="4" />
	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="locating">
		<xsl:element name="locating">
			<xsl:attribute name="id">locating_<xsl:number count="locating" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="typeinGroup">
		<xsl:element name="typeinGroup">
			<xsl:attribute name="id">typeinGroup_<xsl:number count="typeinGroup" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="typein">
		<xsl:element name="typein">
			<xsl:attribute name="id">typein_<xsl:number count="typein" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mlTypein">
		<xsl:element name="mlTypein">
			<xsl:attribute name="id">mlTypein_<xsl:number count="mlTypein" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="radio">
		<xsl:element name="radio">
			<xsl:attribute name="id">radio_<xsl:number count="radio" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="checkbox">
		<xsl:element name="checkbox">
			<xsl:attribute name="id">checkbox_<xsl:number count="checkbox" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="eSpan">
		<xsl:element name="eSpan">
			<xsl:attribute name="id">eSpan_<xsl:number count="eSpan" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="eDiv">
		<xsl:element name="eDiv">
			<xsl:attribute name="id">eDiv_<xsl:number count="eDiv" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="dropDown[not(ancestor::locating)]">
		<xsl:element name="dropDown">
			<xsl:attribute name="id">dropDown_<xsl:number count="dropDown" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="droppable">
		<xsl:element name="droppable">
			<xsl:attribute name="id">droppable_<xsl:number count="droppable" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexDroppable">
		<xsl:element name="complexDroppable">
			<xsl:attribute name="id">complexDroppable_<xsl:number count="complexDroppable" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="ordering">
		<xsl:element name="ordering">
			<xsl:attribute name="id">ordering_<xsl:number count="ordering" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexOrdering">
		<xsl:element name="complexOrdering">
			<xsl:attribute name="id">complexOrdering_<xsl:number count="complexOrdering" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="positioning">
		<xsl:element name="positioning">
			<xsl:attribute name="id">positioning_<xsl:number count="positioning" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="interactiveTextBlock">
		<xsl:element name="interactiveTextBlock">
			<xsl:attribute name="id">itb_<xsl:number count="interactiveTextBlock" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="item[not(ancestor::categorise)]">
		<xsl:element name="item">
			<xsl:attribute name="id">item_<xsl:number count="item" level="single"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="categorise">
		<xsl:element name="categorise">
			<xsl:attribute name="id">categorise_<xsl:number count="categorise" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexCategorise">
		<xsl:element name="complexCategorise">
			<xsl:attribute name="id">complexCategorise_<xsl:number count="complexCategorise" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="categorise/category">
		<xsl:element name="category">
			<xsl:attribute name="id">category_<xsl:number count="category" level="any" from="categorise"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexCategorise/categories/category">
		<xsl:element name="category">
			<xsl:attribute name="id">complexCategory_<xsl:number count="category" level="any" from="categories"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- categorise items have to have the id unique at 'categorise' level -->
	<xsl:template match="item[ancestor::categorise]">
		<xsl:element name="item">
			<xsl:attribute name="id">item_<xsl:number count="item" level="any" from="categorise"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!--
	wordsearch / crossword / etc
	-->
	<xsl:template match="crossword">
		<xsl:element name="crossword">
			<xsl:attribute name="id">crossword_<xsl:number count="crossword" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="crossword//word">
		<xsl:element name="word">
			<xsl:attribute name="id">crossword_word_<xsl:number count="word" level="any" from="crossword"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="verticalCrossword">
		<xsl:element name="verticalCrossword">
			<xsl:attribute name="id">vc_<xsl:number count="verticalCrossword" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="verticalCrossword/word">
		<xsl:element name="word">
			<xsl:attribute name="id">vc_word_<xsl:number count="word" level="any" from="verticalCrossword"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="wordSearch">
		<xsl:element name="wordSearch">
			<xsl:attribute name="id">wordsearch_<xsl:number count="wordSearch" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="wordSearch//word">
		<xsl:element name="word">
			<xsl:attribute name="id">wordesearch_word_<xsl:number count="word" level="any" from="wordSearch"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="wordSnake">
		<xsl:element name="wordSnake">
			<xsl:attribute name="id">wordSnake_<xsl:number count="wordSnake" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="wordSnake//word">
		<xsl:element name="word">
			<xsl:attribute name="id">wordSnake_word_<xsl:number count="word" level="any" from="wordSnake"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="matching">
		<xsl:element name="matching">
			<xsl:attribute name="id">matching_<xsl:number count="matching" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="matching//matchItem">
		<xsl:element name="matchItem">
			<xsl:attribute name="id">matchItem_<xsl:number count="matchItem" level="any" from="matching"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="matching//matchTarget">
		<xsl:element name="matchTarget">
			<xsl:attribute name="id">matchTarget_<xsl:number count="matchTarget" level="any" from="matching"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexMatching">
		<xsl:element name="complexMatching">
			<xsl:attribute name="id">complexmatching_<xsl:number count="complexMatching" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="matchItems/matchItem">
		<xsl:element name="matchItem">
			<xsl:attribute name="id">complex_matchitem_<xsl:number count="matchItem" level="any" from="matchItems"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="matchTargets/matchTarget">
		<xsl:element name="matchTarget">
			<xsl:attribute name="id">complex_matchTarget_<xsl:number count="matchTarget" level="any" from="matchTargets"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexMatching/matchItems">
		<xsl:comment>the 'acceptable/item' IDs must relate to existing matchTarget ID's and need manual assigning according to the manuscript</xsl:comment>
		<xsl:element name="matchItems">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="complexMatching//matchItem//item">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="hangman">
		<xsl:element name="hangman">
			<xsl:attribute name="id">hangman_<xsl:number count="hangman" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="hangman//word">
		<xsl:element name="word">
			<xsl:attribute name="id">hangman_word_<xsl:number count="word" level="any" from="hangman"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<!--
		unmarked ones !
	-->
	<xsl:template match="mlTextInput">
		<xsl:element name="mlTextInput">
			<xsl:attribute name="id">mlTextInput_<xsl:number count="mlTextInput" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="textInput">
		<xsl:element name="textInput">
			<xsl:attribute name="id">textInput_<xsl:number count="textInput" level="any" from="activity"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<!-- deep copy any other attributes / elements -->
	<xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
	<!-- -->

</xsl:stylesheet>