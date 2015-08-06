<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="rows" select="2" />
  <xsl:param name="cols" select="4" />
  <xsl:variable name="pageSize" select="$rows * $cols" />
  <xsl:variable name="pageFormat" select="'A7'" />

  <xsl:include href="template.xsl"/>

  <xsl:template match="item" mode="front">
    <div class="card item card-{(count(preceding-sibling::item) mod $pageSize) + 1}">
      <xsl:attribute name="style">background: rgba(222, 222, 222, 0.5) url(<xsl:value-of select="background"/>) no-repeat 50% 50%; background-size: contain</xsl:attribute>

      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="description"/>
    </div>
  </xsl:template>

  <xsl:template match="item" mode="back">
    <div class="card item cardb-{(count(preceding-sibling::item) mod $pageSize) + 1}">
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="background">
  </xsl:template>
</xsl:stylesheet>
