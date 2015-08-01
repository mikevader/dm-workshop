<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



  <xsl:template match="item" mode="front">
    <div class="card item card-{(count(preceding-sibling::item) mod $pageSize) + 1}">
      <xsl:apply-templates select="name"/>
    </div>
  </xsl:template>

  <xsl:template match="item" mode="back">
    <div class="card item cardb-{(count(preceding-sibling::item) mod $pageSize) + 1}">
      <xsl:apply-templates select="name"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
