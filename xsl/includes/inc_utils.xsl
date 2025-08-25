<?xml version="1.0" encoding="UTF-8"?>
<!--
	IMPORTANT !

	We use exslt extensions here (incliude with libxslt processor) which give us extra functionality for tokenising strings etvc
	HOWEVER !
	When we use xspec tests, these extensions are not available and need to be mocked in the test_*.xsl file *AND* you need to
	signify that the test_* stylesheet verion is 2.0 in order to get it working !

-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	xmlns:set="http://exslt.org/sets"
	extension-element-prefixes="exsl str set"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
>

	<xsl:include href="../utilities/str.replace.template.xsl" />

	<xsl:variable name="oldChars">&#96;&#180;&#8216;&#8217;&#8218;&#8219;&#8220;&#8221;&#8222;&#8223;&#173;&#1418;&#1470;&#6150;&#8208;&#8209;&#8210;&#8211;&#8212;&#8213;&#8722;&#11834;&#11835;&#65112;&#65123;&#65293;</xsl:variable>
	<xsl:variable name="toChars">&apos;&apos;&apos;&apos;&apos;&apos;&quot;&quot;&quot;&quot;----------------</xsl:variable>

	<!-- *******************************************************************************************
			utility template to replace strings
		 ******************************************************************************************* -->
	<xsl:template name="stringreplace">
		<xsl:param name="stringvalue" />
		<xsl:param name="from" />

		<xsl:choose>
			<xsl:when test="contains($stringvalue, $from)"><xsl:value-of select="substring-before($stringvalue, $from)" />
				<xsl:if test="contains(substring($stringvalue, 1, string-length($stringvalue) - 1), $from)">
					<xsl:call-template name="stringreplace">
						<xsl:with-param name="stringvalue" select="substring-after($stringvalue, $from)" />
						<xsl:with-param name="from" select="$from" />
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$stringvalue" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
		utility template to return the 'xpath' path of any passed element
	-->
	<xsl:template name="genPath">
		<xsl:param name="prevPath"/>
		<xsl:variable name="nodeName">
			<xsl:choose>
				<xsl:when test="name()=''">text()</xsl:when>
				<xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currPath">
			<xsl:choose>
				<xsl:when test="$nodeName!='text()'">
					<xsl:value-of select="concat('/', name(), '[', count(preceding-sibling::*[name() = name(current())])+1, ']', $prevPath)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('/', $nodeName, '[', count(preceding-sibling::text())+1,']',$prevPath)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="parent::*">
			<xsl:call-template name="genPath">
				<xsl:with-param name="prevPath" select="$currPath"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:if test="not(parent::*)">
			<xsl:value-of select="$currPath"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="escapeQuote">
		<xsl:param name="pText" select="."/>
		<xsl:variable name="useText">
			<xsl:choose>
				<xsl:when test="not(starts-with($pText, ' '))"><xsl:value-of select="normalize-space(translate($pText, $oldChars, $toChars))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$pText"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($useText) >0">
			<xsl:value-of select=
				"substring-before(concat($useText, '&quot;'), '&quot;')"/>
			<xsl:if test="contains($useText, '&quot;')">
				<xsl:text>\"</xsl:text>
				<xsl:call-template name="escapeQuote">
					<xsl:with-param name="pText" select="substring-after($useText, '&quot;')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="split">
		<xsl:param name="list" select="''"/>
		<xsl:param name="separator" select="','"/>
		<xsl:if test="not($list = '' or $separator = '')">
			<xsl:variable name="head" select="substring-before(concat($list, $separator), $separator)"/>
			<xsl:variable name="tail" select="substring-after($list, $separator)"/>
			"<xsl:value-of select="$head"/>"<xsl:if test="not($tail='')">,</xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="list" select="$tail"/>
				<xsl:with-param name="separator" select="$separator"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandAnswers">
		<xsl:param name="stringVal"/>
		<xsl:param name="quoteAnswers" select="'y'"/>

		<!--
			no access to an 'environment' parameter in create_json_answers, so calculate using existence of $host
		-->
		<xsl:variable name="contractionsUrl">
			<xsl:choose>
				<xsl:when test="not($host='')"><xsl:value-of select="$host"/>/engineFilesRoot/<xsl:value-of select="$engineIdentifier"/>/rcf/xsl/contractions.xml</xsl:when>
				<xsl:otherwise>../contractions.xml</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- expand any contractions -->
		<xsl:variable name="contractionString">
			<xsl:call-template name="str:replace">
				<xsl:with-param name="string" select="$stringVal"/>
				<xsl:with-param name="search"  select="document($contractionsUrl)//from"/>
				<xsl:with-param name="replace" select="document($contractionsUrl)//to"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- replace any empty tokens -->
		<xsl:variable name="useString">
			<xsl:choose>
				<xsl:when test="contains($contractionString, '{|') or contains($contractionString, '|}')">
					<xsl:call-template name="str:replace">
						<xsl:with-param name="string">
							<xsl:call-template name="str:replace">
								<xsl:with-param name="string" select="$contractionString"/>
								<xsl:with-param name="search" select="'{|'"/>
								<xsl:with-param name="replace" select="'{rcf:token|'"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="search" select="'|}'"/>
						<xsl:with-param name="replace" select="'|rcf:token}'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$contractionString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="results"><xsl:call-template name="str:replace"><xsl:with-param name="string"><xsl:call-template name="expandAllAnswers"><xsl:with-param name="stringVal" select="$useString"/><xsl:with-param name="quoteAnswers" select="$quoteAnswers"/></xsl:call-template></xsl:with-param><xsl:with-param name="search" select="'rcf:token'"/><xsl:with-param name="replace" select="''"/></xsl:call-template></xsl:variable>

		<xsl:choose>
			<xsl:when test="count(str:tokenize(normalize-space($results), '|')) &lt; 2"><xsl:value-of select="normalize-space(substring($results, 1, string-length($results)-1))"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="normalize-space($results)"/></xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="expandAllAnswers" >
		<xsl:param name="stringVal" />
		<xsl:param name="quoteAnswers" select="'y'"/>


		<xsl:variable name="head"><xsl:value-of select="substring-before($stringVal, '{')"/></xsl:variable>
		<xsl:variable name="tail"><xsl:value-of select="substring-after($stringVal, '}')"/></xsl:variable>

		<xsl:choose>
			<xsl:when test="contains($stringVal, '{') ">
				<xsl:variable name="list"><xsl:value-of select="substring-before(substring-after($stringVal, '{'), '}')"/></xsl:variable>
				<xsl:if test="count(str:tokenize($list, '|'))=1">
					<xsl:call-template name="expandAllAnswers">
						<xsl:with-param name="stringVal"><xsl:value-of select="$head"/><xsl:value-of select="$tail"/></xsl:with-param>
						<xsl:with-param name="quoteAnswers"><xsl:value-of select="$quoteAnswers"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="str:tokenize($list, '|')">
					<xsl:call-template name="expandAllAnswers">
						<xsl:with-param name="stringVal"><xsl:value-of select="$head"/><xsl:value-of select="."/><xsl:value-of select="$tail"/></xsl:with-param>
						<xsl:with-param name="quoteAnswers"><xsl:value-of select="$quoteAnswers"/></xsl:with-param>
					</xsl:call-template>

				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:if test="$quoteAnswers='y'">"</xsl:if><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$stringVal"/></xsl:call-template><xsl:if test="$quoteAnswers='y'">"</xsl:if>|</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="countStandardInteractionsWithWordBox">
		<xsl:variable name="numberOfDroppableInteractions">
			<xsl:choose>
				<xsl:when test="count(//droppable) &gt; 0">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="numberOfComplexDroppableInteractions"><xsl:value-of select="count(//complexDroppableBlock)"/></xsl:variable>
		<xsl:variable name="numberOfMovableCategorise"><xsl:value-of select="count(//categorise[@desktopDisplay='draggable' or @mobileDisplay='touchable'])"/></xsl:variable>
		<xsl:variable name="numberOfMovableComplexCategorise"><xsl:value-of select="count(//complexCategorise[@desktopDisplay='draggable' or @mobileDisplay='touchable'])"/></xsl:variable>
		<xsl:variable name="numberOfSentenceBuilder"><xsl:value-of select="count(//sentenceBuilder)"/></xsl:variable>
		<xsl:variable name="numberOfWordInsert"><xsl:value-of select="count(//wordInsert)"/></xsl:variable>
		<xsl:value-of select="$numberOfDroppableInteractions + $numberOfComplexDroppableInteractions + $numberOfMovableCategorise + $numberOfMovableComplexCategorise + $numberOfSentenceBuilder + $numberOfWordInsert"/>
	</xsl:template>

	<xsl:template name="removeDuplicates">
		<xsl:param name="string"/>
		<xsl:for-each select="set:distinct(str:tokenize($string,' '))">
			<xsl:value-of select="."/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="generateId">
		<xsl:param name="element"/>
		<xsl:value-of select="generate-id($element)"/>-<xsl:value-of select="ancestor::activity/@id"/>
	</xsl:template>

</xsl:stylesheet>
