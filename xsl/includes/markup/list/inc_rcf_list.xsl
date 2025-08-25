<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   version="1.0">

	<!-- output a generic 'list' -->
	<xsl:template match="list[not(@collapsible) or @collapsible='' or @collapsible='default' or (@collapsible and count(child::li) = 1)]">
		<xsl:apply-templates select="." mode="outputList"/>
	</xsl:template>

	<xsl:template match="list[@collapsible and not(@collapsible='') and not(@collapsible='default') and not(count(child::li) = 1)]">
		<xsl:variable name="initialCollapsibleClass">
			<xsl:choose>
				<xsl:when test="@collapsible='collapsed'">collapsed</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="activityId"><xsl:value-of select="ancestor::activity/@id"/></xsl:variable>

		<xsl:variable name="listIndex">
			<xsl:value-of select="count(preceding::list[@collapsible and not(@collapsible='') and not(@collapsible='default') and not(count(child::li) = 1)]) + 1"/>
		</xsl:variable>

		<xsl:variable name="uniqueListId" select="concat('collapsibleList_content-', $activityId, '-', $listIndex)"/>

		<div data-rcfinteraction="collapsibleList"
			data-ignoreNextAnswer="y"
			data-default="{@collapsible}"
			class="{normalize-space(concat('collapsibleList ', $initialCollapsibleClass))}">

			<div class="collapsibleListControls">
				<div class="collapsibleListToggleContainer">
					<button class="toggle-collapsibleList"
						type="button"
						aria-controls="{$uniqueListId}"
					>
						<xsl:attribute name="aria-expanded">
							<xsl:choose>
								<xsl:when test="@collapsible='collapsed'">false</xsl:when>
								<xsl:otherwise>true</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<span class="label_collapse" data-rcfTranslate="">[ interactions.collapsibleList.showOneByOne ]</span>
						<span class="label_expand" data-rcfTranslate="">[ interactions.collapsibleList.showAll ]</span>
						<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
							<g id="chevron-down" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
								<polyline id="chevron" stroke="#000000" stroke-width="2" transform="translate(16.000000, 17.000000) scale(-1, 1) rotate(-270.000000) translate(-16.000000, -17.000000) " points="11.2273024 2 21 17 11 32"></polyline>
							</g>
						</svg>
					</button>
				</div>

				<div class="collapsibleListNavigationContainer">
					<button class="itemNavigation previousItem"
						type="button"
						data-rcfTranslate=""
						aria-label="[ components.list.previousItem ]"
						aria-controls="{$uniqueListId}"
						disabled="">
						<span class="visually-hidden" data-rcfTranslate="">[ components.list.previousItem ]</span>
						<span class="remainingItems" aria-hidden="true">0</span>
						<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
							<g id="previous">
								<polyline id="icon-previous" fill="none" stroke="#4A4A4A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" points="18.9,7.5 10,15.9 19,24.5"/>
							</g>
						</svg>
					</button>
					<div class="listItemIndex" role="tablist" data-rcfTranslate="" aria-label="[ components.list.listItemsNavigation ]">
						<xsl:for-each select="li">
							<xsl:variable name="activeClassName">
								<xsl:if test="position() = 1">activeIndex</xsl:if>
							</xsl:variable>
							<button class="{normalize-space(concat('itemNavigation itemIndex ', $activeClassName))}"
								type="button"
								data-index="{position()}"
								role="tab"
								id="{$uniqueListId}-tab-{position()}"
								aria-controls="{$uniqueListId}-panel-{position()}">
								<xsl:attribute name="aria-selected">
									<xsl:choose>
										<xsl:when test="position() = 1 and $initialCollapsibleClass = 'collapsed'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="position()"/>
							</button>
						</xsl:for-each>
					</div>
					<button class="itemNavigation nextItem"
						type="button"
						data-rcfTranslate=""
						aria-label="[ components.list.nextItem ]"
						aria-controls="{$uniqueListId}">
						<xsl:if test="count(li)=1">
							<xsl:attribute name="disabled"/>
						</xsl:if>
						<span class="visually-hidden" data-rcfTranslate="">[ components.list.nextItem ]</span>
						<span class="remainingItems" aria-hidden="true"><xsl:value-of select="count(li)-1"/></span>
						<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
							<g id="next">
								<polyline id="icon-next" fill="none" stroke="#4A4A4A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" points="13.6,7.5 22.5,15.9 13.5,24.5"/>
							</g>
						</svg>
					</button>
				</div>
			</div>
			<xsl:apply-templates select="." mode="outputList">
				<xsl:with-param name="listId" select="$uniqueListId"/>
			</xsl:apply-templates>
		</div>

	</xsl:template>

	<xsl:template match="list" mode="outputList">
		<xsl:param name="listId"/>
		<xsl:variable name="isCollapsibleList"><xsl:if test="(@collapsible='collapsed' or @collapsible='expanded') and not(count(child::li) = 1)">y</xsl:if></xsl:variable>
		<xsl:variable name="collapsibleClass">
			<xsl:if test="$isCollapsibleList='y'">collapsibleList_content</xsl:if>
		</xsl:variable>
		<xsl:variable name="orientation">
			<xsl:choose>
				<xsl:when test="@display='h'">horizontal</xsl:when>
				<xsl:when test="@display='v'">vertical</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="className">
			<xsl:value-of select="@type"/>
			<xsl:if test="$orientation!=''"><xsl:text> </xsl:text></xsl:if>
			<xsl:value-of select="$orientation"/>
		</xsl:variable>
		<!-- if numbered and contains *only* sortable lists, then add class 'sortableLists' -->
		<xsl:variable name="extraClass">
			<xsl:if test="count(.//sort)">sortableLists</xsl:if>
		</xsl:variable>
		<xsl:variable name="childCount">li<xsl:value-of select="count(child::li)"/></xsl:variable>

		<xsl:choose>
			<xsl:when test="@type='numbered' or @type='alpha' or @type='upper-alpha' or @type='roman'">
				<ol class="{normalize-space(concat($className, ' ', @class, ' ', $collapsibleClass, ' ', $extraClass, ' ', $childCount))}">
					<xsl:if test="$listId">
						<xsl:attribute name="id"><xsl:value-of select="$listId"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$isCollapsibleList='y'">
						<xsl:attribute name="aria-live">polite</xsl:attribute>
					</xsl:if>
					<xsl:if test="@start">
						<xsl:attribute name="start"><xsl:value-of select="@start"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@reversed='y'">
						<xsl:attribute name="reversed">reversed</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates>
						<xsl:with-param name="listId" select="$listId"/>
					</xsl:apply-templates>
				</ol>
			</xsl:when>
			<xsl:otherwise>
				<ul class="{normalize-space(concat($className, ' ', @class, ' ', $collapsibleClass, ' ', $extraClass, ' ', $childCount))}">
					<xsl:if test="$listId">
						<xsl:attribute name="id"><xsl:value-of select="$listId"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$isCollapsibleList='y'">
						<xsl:attribute name="aria-live">polite</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates>
						<xsl:with-param name="listId" select="$listId"/>
					</xsl:apply-templates>
				</ul>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="li">
		<xsl:param name="listId"/>
		<xsl:variable name="activeClass">
			<xsl:if test="count(preceding-sibling::li)=0 and not(count(following-sibling::li)=0) and (../@collapsible='collapsed' or ../@collapsible='expanded')"> active </xsl:if>
		</xsl:variable>
		<xsl:variable name="className">
			<xsl:if test="@class">
				<xsl:value-of select="@class"/>
			</xsl:if>
			<xsl:value-of select="$activeClass"/>
			<xsl:if test="@numbered='n'"> unnumbered </xsl:if>
		</xsl:variable>
		<xsl:variable name="startNum">
			<xsl:choose>
				<xsl:when test="../@start"><xsl:value-of select="../@start"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li>
			<xsl:if test="$className!=''"><xsl:attribute name="class"><xsl:value-of select="normalize-space($className)"/></xsl:attribute></xsl:if>
			<xsl:if test="not (@numbered='n')">
				<xsl:attribute name="value"><xsl:value-of select="count(preceding-sibling::li[not(@numbered='n')])+($startNum)"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="$listId">
				<xsl:attribute name="id"><xsl:value-of select="concat($listId, '-panel-', count(preceding-sibling::li) + 1)"/></xsl:attribute>
				<xsl:attribute name="aria-labelledby"><xsl:value-of select="concat($listId, '-tab-', count(preceding-sibling::li) + 1)"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="$listId and (../@collapsible = 'collapsed')">
                <xsl:attribute name="role">tabpanel</xsl:attribute>
            </xsl:if>


			<xsl:if test="../@collapsible='collapsed' and not(count(preceding-sibling::li)=0 and count(following-sibling::li)=0)">
				<xsl:attribute name="aria-hidden">
					<xsl:choose>
						<xsl:when test="normalize-space($activeClass) = 'active'">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="list[@collapsible and @collapsible!='default']" mode="getUnmarkedInteractionName">
		rcfCollapsibleList
	</xsl:template>

	<xsl:template match="text()" mode="outputList"/>

</xsl:stylesheet>
