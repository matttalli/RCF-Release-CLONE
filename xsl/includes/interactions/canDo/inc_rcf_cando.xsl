<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- create the HTML for a 'canDo' interactive -->
	<xsl:template match="canDo">
		<xsl:variable name="orientation">
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
				<xsl:otherwise>vertical</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="numCanDos">
			<xsl:choose>
				<xsl:when test="not(@outOf)=''"><xsl:value-of select="@outOf"/></xsl:when>
				<xsl:otherwise>5</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<ul
			data-rcfinteraction="canDo"
			data-rcfid="{@id}"
			class="{normalize-space(concat('canDoList ', @type, ' ', $orientation))}"
			data-mark="list"
		>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>
			<xsl:for-each select="item">
				<li>
					<xsl:apply-templates/>
					<br />
					<div class="textControls canDoItem" data-rcfid="canDoItem_{position()}">
						<xsl:call-template name="outputCanDo">
							<xsl:with-param name="i">0</xsl:with-param>
							<xsl:with-param name="count"><xsl:value-of select="$numCanDos"/></xsl:with-param>
						</xsl:call-template>
					</div>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<!-- output individual canDo elements - this way we can test our position and which 'class' we need to assign to it -->
	<xsl:template name="outputCanDo">
		<xsl:param name="i"/>
		<xsl:param name="count"/>

		<xsl:variable name="buttonClass">
			<xsl:choose>
				<xsl:when test="$i &lt; 1">leftButton</xsl:when>
				<xsl:when test="$i = ($count - 1)">rightButton</xsl:when>
				<xsl:otherwise>middleButton</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$i &lt; $count">
			<a class="{$buttonClass} canDoButton" href="javascript:;" data-level="{$i+1}"><xsl:value-of select="$i+1"/></a>
		</xsl:if>

		<xsl:if test="$i &lt; $count">
			<xsl:call-template name="outputCanDo">
				<xsl:with-param name="i"><xsl:value-of select="$i+1"/></xsl:with-param>
				<xsl:with-param name="count"><xsl:value-of select="$count"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="canDo" mode="getUnmarkedInteractionName">
		rcfCanDo
	</xsl:template>

</xsl:stylesheet>
