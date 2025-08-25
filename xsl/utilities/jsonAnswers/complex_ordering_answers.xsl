<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="complexOrdering[not(@example='y')]" mode="outputAnswers">
		<!-- complexOrdering should only have markType of 'list' -->
		<xsl:variable name="complexOrderingId" select="@id"/>
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "complexordering",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": [
				[<xsl:for-each select="items/item[not(@fixed='y')]">"<xsl:value-of select="@id"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
				<xsl:if test="alternativeOrderings">
				,
					<xsl:for-each select="alternativeOrderings/order">
				<!-- ooh complicated
					have to perform lookups between alternativeOrdering/order/item and complexOrdering/items/item
					to determine that no 'fixed' items are included in the answers
					*THEN* have to remove the extra '*REMOVE-ME*' token that is added - items always have a ','
					output after them, then at the end is ',*REMOVE-ME*' - that entire string is then 
					removed to generate valid json - all other solutions with xsl:key etc were fragile / too tricky 
					to implement - sometimes bruteforce is best !
				-->
<!-- 
eg:
    		<complexOrdering id="complexOrdering_3c">
                <items>
				    <item id="c1" fixed="y">I</item>
				    <item id="c2">like</item>
				    <item id="c3">bananas</item>
                    <item id="c4" fixed="y" rank="4">and (4)</item>
                    <item id="c5">apples</item>
			    </items>
			    <alternativeOrderings>
                    <order>
                        <item id="c1"/>
                        <item id="c2"/>
                        <item id="c5"/>
                        <item id="c4"/>
                        <item id="c3"/>
                    </order>
			    </alternativeOrderings>
			</complexOrdering>
-->				
				[
					<xsl:variable name="nonFixedItems">
					<xsl:for-each select="item">
						<xsl:variable name="currentItemId" select="@id"/>
						<xsl:if test="ancestor::complexOrdering/items/item[@id=current()/@id and not(@fixed='y')]">"<xsl:value-of select="@id"/>",</xsl:if>
					</xsl:for-each>*REMOVE-ME*</xsl:variable>
					<xsl:call-template name="str:replace">
						<xsl:with-param name="string" select="$nonFixedItems"/>
						<xsl:with-param name="search"  select="',*REMOVE-ME*'"/>
						<xsl:with-param name="replace" select="''"/>
					</xsl:call-template>
				]<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
			</xsl:if>
			]
		}
	</xsl:template>

</xsl:stylesheet>