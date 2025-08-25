<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- create the HTML for the 'dropDown' interactive -->
	<xsl:template match="dropDown | itemDropDown" >
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="itemBasedClass"><xsl:if test="name() = 'itemDropDown'">itemDropDown</xsl:if></xsl:variable>

		<!-- contained in an inline span element -->
		<span data-rcfid="{@id}"
			data-rcfinteraction="dropDown"
			class="{normalize-space(concat('dropDown ', $exampleClass))}"
		>

			<xsl:if test="$authoring='Y'">
				<xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="prefix">
				<span class="prefix"><xsl:value-of select="prefix"/></span>
			</xsl:if>

			<span class="{normalize-space(concat('markable dev-markable-container ', $itemBasedClass, ' ', @class))}">
				<!--  data-native-menu used by jquery mobile for apps -->
				<select data-native-menu="false">
					<xsl:if test="@example='y'">
						<xsl:attribute name="class">example</xsl:attribute>
						<!-- as of RCF-10994: all examples will now be set as disabled -->
						<xsl:attribute name="disabled"/>
					</xsl:if>
					<!-- output empty option if using custom select elements from jqueryui -->
					<xsl:if test="$dropDownListOutput='y'">
						<option data-rcfid="" value="" selected=""/>
					</xsl:if>
					<!-- output option elements -->
					<xsl:apply-templates/>
				</select>
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</span>
			<xsl:if test="suffix">
				<span class="suffix"><xsl:value-of select="suffix"/></span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="dropDown/item | itemDropDown/item">
		<option data-rcfid="{@id}" value="{@id}">
			<xsl:if test="@correct='y' and ../@example='y'">
				<xsl:attribute name="selected"/>
				<xsl:attribute name="class">dev-example-answer</xsl:attribute>
			</xsl:if>
			<!--
				RCF-9041
				if the <dropDown example=y> *AND* it's dropdown list output, then set every <option> element to *disabled*
				- even though the <select> is hidded, the new div/span jqueryui wrapper handles it correctly
				- we *DONT* do this for non-dropdownList output because not all browser suppord 'disabled' as an attribute on <option> ...
				   .... or at least, they didn't when I first wrote this back in the olden times :)
				TODO:
				At a later date, I recommend we remove the "and $dropDownListOutput='y'" condition below and then
				run tests in all browsers we support to ensure that code still works (can't see why it shouldn't !)
			-->
			<!-- <xsl:if test="../@example='y' and $dropDownListOutput='y'"><xsl:attribute name="disabled"/></xsl:if> -->
			<xsl:value-of select="."/>
		</option>
	</xsl:template>

	<!-- rcf_dropdown -->
	<xsl:template match="dropDown[not(ancestor::locating)]" mode="getRcfClassName">
		rcfDropDown
	</xsl:template>

	<!-- rcf_itembased_dropdown -->
	<xsl:template match="itemDropDown" mode="getItemBasedRcfClassName">
		rcfItemBasedDropDown
	</xsl:template>

</xsl:stylesheet>
