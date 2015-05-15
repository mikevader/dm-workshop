<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes" />

  <xsl:include href="spell_template.xsl"/>
<!--
  <xsl:include href="monster_template.xsl"/>
  <xsl:include href="item_template.xsl"/>
-->


  <xsl:param name="rows" select="2" />
  <xsl:param name="cols" select="4" />
  <xsl:variable name="pageSize" select="$rows * $cols" />

  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="cards.css"/>
      </head>
      <body>
        <xsl:apply-templates select="cards/spell[position() mod $pageSize = 1]" />
      </body>
    </html>
  </xsl:template>

  <xsl:template match="spell">
    <!-- fronts -->
    <xsl:call-template name="printRows">
      <xsl:with-param name="mode" select="'front'"/>
      <xsl:with-param name="order" select="'ascending'" />
    </xsl:call-template>
    <!-- backs -->
    <xsl:call-template name="printRows">
      <xsl:with-param name="mode" select="'back'"/>
      <xsl:with-param name="order" select="'descending'" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="printRows">
    <xsl:param name="mode" />
    <xsl:param name="order" />
    <xsl:variable name="thePage"
        select=". | following-sibling::spell[position() &lt; $pageSize]" />
    <!-- split into rows -->
    <xsl:for-each select="$thePage[position() mod $cols = 1]">
      <xsl:variable name="theRow"
          select=". | following-sibling::spell[position() &lt; $cols]" />

      <xsl:if test="$order = 'descending'">
        <!--
        special case for a short reverse row (i.e. the last row of the last page) - we need
        to left-pad this row with empty columns to get the right positioning
        -->
        <xsl:call-template name="emptyDivs">
          <xsl:with-param name="num" select="$cols - count($theRow)" />
        </xsl:call-template>
      </xsl:if>

      <!-- <xsl:apply-templates select="$theRow/*[$element]"> -->

      <!-- and process each row in appropriate order -->

      <xsl:choose>
        <xsl:when test="$mode = 'front'">
          <xsl:apply-templates select="$theRow" mode="front">
            <xsl:sort select="position()" order="{$order}" data-type="number" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$theRow" mode="back">
            <xsl:sort select="position()" order="{$order}" data-type="number" />
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
<!--
  <xsl:template match="spell" mode="front">
    <xsl:apply-templates select="name" />
  </xsl:stylesheet>

  <xsl:template match="spell" mode="back">
    <xsl:apply-templates select="description" />
  </xsl:stylesheet>
-->
  <xsl:template name="emptyDivs">
    <xsl:param name="num"/>
    <xsl:if test="$num &gt; 0">
      <div class="padding back" />
      <xsl:call-template name="emptyDivs">
        <xsl:with-param name="num" select="$num - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
<!--
  <xsl:template match="name">
    <div class="card{(count(../preceding-sibling::spell) mod $pageSize) + 1} front">
      <xsl:value-of select="." />
    </div>
  </xsl:template>

  <xsl:template match="description">
    <div class="card{(count(../preceding-sibling::spell) mod $pageSize) + 1} back">
      <xsl:copy-of select="text()" />
    </div>
  </xsl:template>
-->
  <xsl:template match="name">
    <div class="name"><xsl:value-of select="."/></div>
  </xsl:template>

  <xsl:template match="description">
    <div class="description">
      <xsl:copy-of select="text()"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
