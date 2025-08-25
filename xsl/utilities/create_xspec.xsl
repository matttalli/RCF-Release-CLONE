<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:x="http://www.jenitennison.com/xslt/xspec"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:param name="xslFileName"/>
	
	<xsl:template match="xsl:stylesheet">
		<x:description xmlns:x="http://www.jenitennison.com/xslt/xspec"
			stylesheet="test_{$xslFileName}"
		>
			<xsl:apply-templates/>
		</x:description>
	</xsl:template>

	<xsl:template match="xsl:template[@match]">
		<x:scenario label="{concat(@match, ' - matched template')}">
			<x:context>
				<xsl:comment> TODO </xsl:comment>
			</x:context>
		</x:scenario>
		<xsl:comment/>
	</xsl:template>

	<xsl:template match="xsl:template[@match][@mode]">
		<x:scenario label="{concat(@match, ' - matched template, with MODE [ ', @mode, ' ]')}">
			<x:context mode="{@mode}">
				<xsl:comment> TODO </xsl:comment>
			</x:context>
		</x:scenario>
		<xsl:comment/>
	</xsl:template>

	<xsl:template match="xsl:template[@name]">

		<x:scenario label="{concat(@name, ' - named template')}">
			<x:call template="{@name}">
				<xsl:apply-templates/>
				<x:context>
					<xsl:comment> TODO </xsl:comment>
				</x:context>
			</x:call>
		</x:scenario>
		<xsl:comment/>
	</xsl:template>

	<xsl:template match="xsl:template[@name]/xsl:param">
		<x:param name="{@name}"/>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>