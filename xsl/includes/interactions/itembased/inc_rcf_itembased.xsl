<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
		new logic for item based:

		1. always check for /activity/itemListContainer first
		2. if that doesn't exist, then check for capePreview / itemsFileName as before

	-->
	<xsl:template match="itemBased">
		<xsl:choose>
			<xsl:when test="/activity/itemListContainer">
				<xsl:call-template name="itemListApplyTemplates">
					<xsl:with-param name="itemListNode" select="/activity/itemListContainer/itemList"/>
					<xsl:with-param name="activityItemBased" select="."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$environment='capePreview'">
				<xsl:if test="/activity/itemListContainer/itemList">
					<xsl:call-template name="itemListApplyTemplates">
						<xsl:with-param name="itemListNode" select="/activity/itemListContainer/itemList"/>
						<xsl:with-param name="activityItemBased" select="."/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not(/activity/itemListContainer/itemList)">
					<div class="itemBasedErrors">
						<h3>Activity is &lt;itemBased&gt; but no <xsl:value-of select="/activity/@id"/>.items file exists</h3>
					</div>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$itemsFileName">
					<xsl:call-template name="verifyItemBasedActivityItems"/>
					<xsl:call-template name="itemListApplyTemplates">
						<xsl:with-param name="itemListNode" select="document($itemsFileName)"/>
						<xsl:with-param name="activityItemBased" select="."/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not($itemsFileName)">
					<div class="itemBasedErrors">
						<h3>Activity is &lt;itemBased&gt; but no <xsl:value-of select="/activity/@id"/>.items file exists</h3>
					</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="itemListApplyTemplates">
	  	<xsl:param name="itemListNode" />
		<xsl:param name="activityItemBased"/>
	  	<xsl:apply-templates select="$itemListNode" mode="itembased">
			<xsl:with-param name="activityItemBased" select="$activityItemBased"/>
			<xsl:with-param name="itemBasedCustomClass" select="$activityItemBased/@class"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="itemList" mode="itembased">
		<xsl:param name="activityItemBased"/>
		<xsl:param name="itemBasedCustomClass"/>

		<div class="main itemBasedQuestionsContainer clearfix {$itemBasedCustomClass}">
			<xsl:apply-templates mode="itembased">
				<xsl:with-param name="activityItemBased" select="$activityItemBased"/>
			</xsl:apply-templates>
		</div>

	</xsl:template>

	<xsl:template match="itemList/item" mode="itembased">
		<xsl:param name="activityItemBased"/>
		<xsl:variable name="itemId" select="@id"/>
		<xsl:variable name="itemSetType" select="$activityItemBased/itemSet[item[@id=$itemId]]/@type"/>

		<xsl:variable name="itemPointsAvailable">
			<xsl:call-template name="itemPoints">
				<xsl:with-param name="item" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div data-itemPointsAvailable="{$itemPointsAvailable}" class="block itemBasedItem itemBasedQuestion {@class}" data-rcfid="{@id}" data-itemSetType="{$itemSetType}">
			<xsl:apply-templates mode="itembased"/>
		</div>
	</xsl:template>

	<xsl:template match="itemRubric" mode="itembased">
		<div class="block itemRubric">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="prompt" mode="itembased">
		<xsl:variable name="extraPromptClasses">
			<xsl:call-template name="elementContentStylingClasses">
				<xsl:with-param name="contentElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<div class="{normalize-space(concat('block prompt ', @class, ' ', $extraPromptClasses))}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="interactive" mode="itembased">
		<div class="block interactive {@class}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="text()" mode="itembased"/>

	<xsl:template name="verifyItemBasedActivityItems">
		<xsl:if test="$itemsFileName">
			<xsl:variable name="itemsDoc" select="document($itemsFileName)"/>
			<xsl:variable name="missingItems"><xsl:for-each select="/activity//itemBased//item"><xsl:variable name="idFromActivity" select="@id"/><xsl:if test="count($itemsDoc//item[@id=$idFromActivity])=0">y</xsl:if></xsl:for-each></xsl:variable>

			<xsl:if test="$missingItems!=''">
				<div class="itemBasedErrors">
					<xsl:for-each select="/activity//itemBased//item">
						<xsl:variable name="idFromActivity" select="@id"/>
						<xsl:if test="count($itemsDoc//item[@id=$idFromActivity])=0">
							<h4>Item with ID : <xsl:value-of select="$idFromActivity"/> does not exist in items file</h4>
						</xsl:if>
					</xsl:for-each>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!--
		create a default template for activiy/itemListContainer - purely for CAPE - this ensures that the xml is not caught
		by the default template processing for cape - only when called with a 'mode' should the itemBased xml be output.
	-->
	<xsl:template match="activity/itemListContainer"/>

</xsl:stylesheet>
