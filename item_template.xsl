<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:template match="item">
    <div class="card item card-{1+count(preceding-sibling::*) mod 8}">
      <xsl:apply-templates select="name"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
