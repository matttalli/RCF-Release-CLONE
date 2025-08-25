<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="imageSet">
		<!-- output the structure for the flex / carousel -->
		<div class="{normalize-space(concat('imageSet flexslider ', @class))}">

			<ul class="slides">
				<xsl:for-each select="image">
					<li>
 						<span class="imageContainer">
						 	<xsl:variable name="imageSrc">
								<xsl:call-template name="getAssetSource">
									<xsl:with-param name="assetSource" select="@src"/>
									<xsl:with-param name="useEnvironment" select="$environment"/>
									<xsl:with-param name="assetPartialPathName" select="'images'"/>
									<xsl:with-param name="useAssetsUrl" select="$levelAssetsURL"/>
								</xsl:call-template>
							</xsl:variable>
							<img src="{$imageSrc}" title="{@title}" alt="{@a11yTitle}"/>
 							<xsl:if test="count(caption)>0">
								<span class="caption {./caption/@type}">
									<span class="innerCaption">
										<xsl:apply-templates/>
									</span>
								</span>
							</xsl:if>
						</span>
 					</li>
				</xsl:for-each>
			</ul>

		</div>
	</xsl:template>

</xsl:stylesheet>
