<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="matching[@isInteraction='y']">
        <div class="{@printClass}" data-rcfid="{@id}">
            <ol class="rcfPrint-matchItems">
                <xsl:apply-templates select="./distractors/item"/>
                <xsl:apply-templates select="./pair/matchItem"/>
            </ol>
            <ol class="rcfPrint-matchTargets">
                <xsl:apply-templates select="./pair/matchTarget"/>
            </ol>
        </div>
    </xsl:template>

    <xsl:template match="matching[@isInteraction='y']/distractors/item">
        <li class="rcfPrint-matchItem rcfPrint-distractor" data-rcfid="{@id}">
            <xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
            <div class="matchElementContainer">
                <div class="matchElementIndex"></div>
                <div class="matchElementContents">
                    <xsl:apply-templates/>
                </div>
            </div>
        </li>
    </xsl:template>

    <xsl:template match="matching[@isInteraction='y']/pair/matchItem">
        <xsl:variable name="exampleClass">
            <xsl:if test="ancestor::pair/@example='y'">example</xsl:if>
        </xsl:variable>
        <li class="{normalize-space(concat('rcfPrint-matchItem', ' ', $exampleClass))}" data-rcfid="{@id}">
            <xsl:attribute name="data-matchTarget"><xsl:value-of select="../matchTarget/@id"/></xsl:attribute>
            <xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
            <div class="matchElementContainer">
                <div class="matchElementIndex"></div>
                <div class="matchElementContents">
                    <xsl:apply-templates/>
                </div>
            </div>
        </li>
    </xsl:template>

    <xsl:template match="matching[@isInteraction='y']/pair/matchTarget">
        <xsl:variable name="exampleClass">
            <xsl:if test="ancestor::pair/@example='y'">example</xsl:if>
        </xsl:variable>
        <li class="{normalize-space(concat('rcfPrint-matchTarget', ' ', $exampleClass))}" data-rcfid="{@id}">
            <xsl:if test="ancestor::pair/@example='y'"><xsl:attribute name="data-matchItem"><xsl:value-of select="../matchItem/@id"/></xsl:attribute></xsl:if>
            <xsl:if test="@rank"><xsl:attribute name="data-rank"><xsl:value-of select="@rank"/></xsl:attribute></xsl:if>
            <xsl:variable name="matchTargetIndex"><xsl:value-of select="count(preceding::matchTarget)+1"/></xsl:variable>
            <div class="matchElementContainer">
                <div class="matchElementIndex"></div>
                <div class="matchElementContents">
                    <xsl:apply-templates/>
                </div>
            </div>
        </li>
    </xsl:template>

    <xsl:template match="matching[@isInteraction='y']//audio">
        <xsl:call-template name="audioIcon"/>
    </xsl:template>


    <xsl:template match="matching[@isInteraction='y']" mode="outputAnswerKeyValueForInteraction">
        <!--
            The matching interaction is written out as 2 lists - these are then randomized / ranked by the javascript

            The javascript will then also need to sort the answer key into the same order as the match items
        -->
        <span class="{@printClass} rcfPrint-answer" data-rcfid="{@id}">
            <xsl:apply-templates select="pair[not(@example='y')]" mode="outputAnswerKey"/>
        </span>
    </xsl:template>

    <xsl:template match="matching[@isInteraction='y']/pair[not(@example='y')]" mode="outputAnswerKey">
        <span class="rcfPrint-item" data-matchItem="{matchItem/@id}" data-matchTarget="{matchTarget/@id}">
            <!-- populated by the rcf.print-runtime.min.js code – but we need to output some text for the AK to not be hidden -->
            <xsl:value-of select="matchItem"/> = <xsl:value-of select="matchTarget"/>
        </span>
    </xsl:template>

</xsl:stylesheet>
