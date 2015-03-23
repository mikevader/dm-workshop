<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="cards.css"/>
      </head>
      <body>
        <h2>Monster</h2>  
        <xsl:apply-templates/>  
      </body>
    </html>
  </xsl:template>

  <xsl:template match="monster">
    <div class="card">
      <xsl:apply-templates select="name"/>
      <hr/>
      <xsl:apply-templates select="stats"/>
      <xsl:apply-templates select="description"/>
    </div>
  </xsl:template>

  <xsl:template match="name">
    <div class="name"><xsl:value-of select="."/></div>
  </xsl:template>

  <xsl:template match="stats">
    <div class="stat">
      <div class="title">Armor Class</div>
      <div class="value"><xsl:value-of select="ac"/></div>
    </div>
    <div class="stat">
      <div class="title">Hip Points</div>
      <div class="value"><xsl:value-of select="hp"/></div>
    </div>
    <div class="stat">
      <div class="title">Speed</div>
      <div class="value"><xsl:value-of select="speed"/></div>
    </div>
    <hr/>
    <xsl:apply-templates select="abilities"/>
    <hr/>
    <xsl:apply-templates select="savingThrows"/>
    <xsl:apply-templates select="skills"/>
    <xsl:apply-templates select="dmgVulnerability"/>
    <xsl:apply-templates select="dmgResistance"/>
    <xsl:apply-templates select="dmgImmunity"/>
    <xsl:apply-templates select="condImmunity"/>
    <xsl:apply-templates select="senses"/>
    <div class="stat">
      <div class="title">Challenge</div>
      <div class="value"><xsl:value-of select="cr"/></div>
    </div>
  </xsl:template>

  <xsl:template match="abilities">
    <div class="abilities">
      <div class="ability">
        <div class="title">Str</div>
        <div class="value"><xsl:value-of select="@str"/></div>
      </div>
      <div class="ability">
        <div class="title">Dex</div>
        <div class="value"><xsl:value-of select="@dex"/></div>
      </div>
      <div class="ability">
        <div class="title">Con</div>
        <div class="value"><xsl:value-of select="@con"/></div>
      </div>
      <div class="ability">
        <div class="title">Int</div>
        <div class="value"><xsl:value-of select="@int"/></div>
      </div>
      <div class="ability">
        <div class="title">Wis</div>
        <div class="value"><xsl:value-of select="@wis"/></div>
      </div>
      <div class="ability">
        <div class="title">Cha</div>
        <div class="value"><xsl:value-of select="@cha"/></div>
      </div>
      <span class="stretch"></span>
    </div>
  </xsl:template>

  <xsl:template match="savingThrows">
    <div class="savingThrows">
      <div class="title">Saving throws</div>
      <div class="ability">
        <div class="title">Str</div>
        <div class="value"><xsl:value-of select="@str"/></div>
      </div>
      <div class="ability">
        <div class="title">Dex</div>
        <div class="value"><xsl:value-of select="@dex"/></div>
      </div>
      <div class="ability">
        <div class="title">Con</div>
        <div class="value"><xsl:value-of select="@con"/></div>
      </div>
      <div class="ability">
        <div class="title">Int</div>
        <div class="value"><xsl:value-of select="@int"/></div>
      </div>
      <div class="ability">
        <div class="title">Wis</div>
        <div class="value"><xsl:value-of select="@wis"/></div>
      </div>
      <div class="ability">
        <div class="title">Cha</div>
        <div class="value"><xsl:value-of select="@cha"/></div>
      </div>
      <span class="stretch"></span>
    </div>
  </xsl:template>

  <xsl:template match="skills">
  </xsl:template>

  <xsl:template match="dmgVulnerability">
  </xsl:template>

  <xsl:template match="dmgResistance">
  </xsl:template>

  <xsl:template match="dmgImmunity">
  </xsl:template>

  <xsl:template match="condImmunity">
  </xsl:template>

  <xsl:template match="senses">
  </xsl:template>

  <xsl:template match="description">
    <div>
      <div class="">Beschreibung</div>
      <div><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

</xsl:stylesheet>
