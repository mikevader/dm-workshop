<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="rows" select="2" />
  <xsl:param name="cols" select="4" />
  <xsl:variable name="pageSize" select="$rows * $cols" />
  <xsl:variable name="pageFormat" select="'A7'" />

  <xsl:include href="template.xsl"/>

  <xsl:template match="reference" mode="front">
    <div class="card reference card-{(count(preceding-sibling::reference) mod $pageSize) + 1}">
      <xsl:attribute name="style"><xsl:value-of select="backgroundStyle"/></xsl:attribute>

      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="description"/>
    </div>
  </xsl:template>

  <xsl:template match="reference" mode="back">
    <div class="card reference cardb-{(count(preceding-sibling::reference) mod $pageSize) + 1}">
      <xsl:attribute name="style"><xsl:value-of select="backgroundStyle"/></xsl:attribute>

      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="description"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
