<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <xsl:apply-templates/>  
  </xsl:template>

  <xsl:template match="spell">
    <div class="card spell">
      <xsl:apply-templates select="*"/>
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
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="range">
    <div class="range">
      <div class="title">Range</div>
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="components">
    <div class="components">
      <div class="title">Components</div>
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="duration">
    <div class="duration">
      <div class="title">Duration</div>
      <xsl:value-of select="."/>
    </div>
  </xsl:template>
</xsl:stylesheet>
