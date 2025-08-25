<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:set="http://exslt.org/sets"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str set"
>
<!--
	these overrides in XSL 2 (!) are required because we use SAXON to run our xspec tests
	but use libxslt (and it's derivatives) with *exslt* extensions in XSL 1... sheesh !

	So we are basically mocking these functions !
-->
	<xsl:function name="exsl:node-set" as="node()">
		<xsl:param name="n" as="node()"/>
		<xsl:sequence select="$n"/>
	</xsl:function>

	<xsl:function name="set:distinct" as="node()">
		<xsl:param name="n" as="node()"/>
		<xsl:sequence select="$n"/>
	</xsl:function>

	<xsl:function name="str:tokenize">
		<xsl:param name="string1"/>
		<xsl:param name="string2"/>
		<xsl:value-of select="$string1"/>
	</xsl:function>

	<xsl:include href="create_rcf_activity.xsl"/>

</xsl:stylesheet>
