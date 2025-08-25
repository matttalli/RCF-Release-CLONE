<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="activity/main">

		<xsl:variable name="wordBoxClasses">
			<xsl:if test="count(.//complexDroppable) &gt; 0">complexDroppable</xsl:if>
		</xsl:variable>

		<div class="main clearfix">
			<xsl:choose>
				<xsl:when test="$wordBoxPosition='top'">
					<xsl:if test="count(.//droppable) &gt; 0 or count(.//complexDroppable) &gt; 0">
						<xsl:call-template name="standardWordBox">
							<xsl:with-param name="activity" select="ancestor::activity"/>
							<xsl:with-param name="className" select="$wordBoxClasses"/>
							<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
							<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:apply-templates />
				</xsl:when>

				<xsl:when test="$wordBoxPosition='default'">
					<xsl:apply-templates/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>

			</xsl:choose>

			<!-- output wordbox at bottom if required -->
			<xsl:if test="$wordBoxPosition='bottom'">
				<xsl:if test="count(.//droppable) &gt; 0 or count(.//complexDroppable) &gt; 0">
					<xsl:call-template name="standardWordBox">
						<xsl:with-param name="activity" select="ancestor::activity"/>
						<xsl:with-param name="className" select="$wordBoxClasses"/>
						<xsl:with-param name="useFixedWordPools" select="$useFixedWordPools"/>
						<xsl:with-param name="useCollapsibleWordPools" select="$collapsibleWordBox"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>

			<!-- output any 'locating' popups -->
			<xsl:apply-templates select=".//locating/dropDown"/>
			<xsl:apply-templates select=".//locating/typein"/>
		</div>

	</xsl:template>

</xsl:stylesheet>
