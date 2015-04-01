<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="monster_template.xsl"/>
  <xsl:import href="spell_template.xsl"/>
  <xsl:import href="item_template.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="cards.css"/>
      </head>
      <body>
        <h2>Kärtchen</h2>  
        <xsl:apply-imports/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="name">
    <div class="name"><xsl:value-of select="."/></div>
  </xsl:template>

  <xsl:template match="description">
    <div class="description">
      <xsl:copy-of select="."/>
    </div>
  </xsl:template>

</xsl:stylesheet>
