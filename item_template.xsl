<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <xsl:apply-templates/>  
  </xsl:template>

  <xsl:template match="item">
    <div class="card item">
      <xsl:apply-templates select="name"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
