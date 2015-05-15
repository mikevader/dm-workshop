<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="spell" mode="front">
    <div class="card spell card-{(count(../preceding-sibling::spell) mod $pageSize) + 1}">
      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="type"/>
      <xsl:apply-templates select="classes"/>
      <xsl:apply-templates select="castingTime"/>
      <xsl:apply-templates select="range"/>
      <xsl:apply-templates select="components"/>
      <xsl:apply-templates select="duration"/>
    </div>
  </xsl:template>

  <xsl:template match="spell" mode="back">
    <div class="card spell cardb-{(count(../preceding-sibling::spell) mod $pageSize) + 1}">
      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="description"/>
    </div>
  </xsl:template>

  <xsl:template match="type">
    <div class="type"><xsl:value-of select="."/></div>
  </xsl:template>

  <xsl:template match="classes">
    <div class="list classes">
      <xsl:for-each select="*">
        <div class="listElement"><xsl:value-of select="."/></div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="castingTime">
    <div class="castingTime">
      <div class="title">Casting Time</div>
      <div class="value"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xsl:template match="range">
    <div class="range">
      <div class="title">Range</div>
      <div class="value"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xsl:template match="components">
    <div class="components">
      <div class="title">Components</div>
      <div class="value"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xsl:template match="duration">
    <div class="duration">
      <div class="title">Duration</div>
      <div class="value"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>
</xsl:stylesheet>
