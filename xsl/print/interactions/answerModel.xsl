<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="answerModel" mode="outputOpenGradableAnswerModel">

		<div class="rcfPrint-answerModel">
			<!-- Answer model header -->
			<p><b data-rcfTranslate="">[ components.label.modelAnswer ]</b></p>

			<!-- Answer model image (if included) -->
			<xsl:if test="@image">
				<xsl:variable name="imageSrc">
					<xsl:call-template name="getAssetSource">
						<xsl:with-param name="assetSource" select="@image"/>
						<xsl:with-param name="useEnvironment" select="$environment"/>
						<xsl:with-param name="assetPartialPathName" select="'images'"/>
						<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
					</xsl:call-template>
				</xsl:variable>
				<img class="rcfPrint-answerModelImage" src="{$imageSrc}"></img>
			</xsl:if>

			<!-- Answer model text (if included) -->
			<xsl:if test="string-length(.) > 0">
				<p><xsl:apply-templates select="."/></p>
			</xsl:if>
		</div>

	</xsl:template>

</xsl:stylesheet>
