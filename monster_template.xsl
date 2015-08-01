<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="monster" mode="front">
    <div class="card monster card-{(count(preceding-sibling::monster) mod $pageSize) + 1}">
      <xsl:apply-templates select="name"/>
      <hr/>
      <xsl:apply-templates select="stats"/>
      <hr/>
      <xsl:apply-templates select="traits"/>
    </div>
  </xsl:template>

  <xsl:template match="monster" mode="back">
    <div class="card monster cardb-{(count(preceding-sibling::monster) mod $pageSize) + 1}">
      <xsl:apply-templates select="name"/>
      <hr/>
      <xsl:apply-templates select="actions"/>
      <xsl:apply-templates select="description"/>
    </div>
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
    <xsl:apply-templates select="cr"/>
  </xsl:template>

  <xsl:template match="abilities">
    <div class="abilities">
      <xsl:for-each select="@*">
        <div class="ability">
          <div class="title"><xsl:value-of select="name()"/></div>
          <div class="value"><xsl:value-of select="."/></div>
        </div>
      </xsl:for-each>
      <span class="stretch"></span>
    </div>
  </xsl:template>

  <xsl:template match="savingThrows">
    <div class="savingThrows">
      <div class="title">Saving throws</div>
      <xsl:for-each select="@*">
        <div class="ability">
          <div class="title"><xsl:value-of select="name()"/></div>
          <div class="value"><xsl:value-of select="."/></div>
        </div>
      </xsl:for-each>
      <span class="stretch"></span>
    </div>
  </xsl:template>

  <xsl:template match="skills">
    <div class="list">
      <div class="title">Skills</div>
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>
  <xsl:template match="skill">
    <div class="listElement">
      <div class="title"><xsl:value-of select="@name"/></div>
      <div class="value"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xsl:template match="dmgVulnerability">
    <xsl:call-template name="damageType">
      <xsl:with-param name="title">Vulnerable</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dmgResistance">
    <xsl:call-template name="damageType">
      <xsl:with-param name="title">Resistance</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dmgImmunity">
    <xsl:call-template name="damageType">
      <xsl:with-param name="title">Immune</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="condImmunity">
    <xsl:call-template name="damageType">
      <xsl:with-param name="title">Cond Immune</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="damageType">
    <xsl:param name="title"/>
    <div class="list vertical">
      <div class="title"><xsl:value-of select="$title"/></div>
      <xsl:for-each select="*">
        <div class="listElement"><xsl:value-of select="name()"/></div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="senses">
    <div class="list">
      <div class="title">Senses</div>
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>
  <xsl:template match="sense">
    <div class="listElement">
      <div class="title"><xsl:value-of select="@name"/></div>
      <div class="value"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xsl:template match="cr">
    <div class="stat">
      <div class="title">Challenge</div>
      <div><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xsl:template match="traits">
    <div class="bulletlist">
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="actions">
    <div class="bulletlist">
      <div class="title">Actions</div>
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="meleeWeaponAttack | rangedWeaponAttack | action | trait">
    <div class="bulletpoint">
      <div class="title"><xsl:value-of select="@name"/>.</div>
      <xsl:if test="name() = 'meleeWeaponAttack'">
        <i>Melee Weapon Attack: </i>
      </xsl:if>
      <xsl:if test="name() = 'rangedWeaponAttack'">
        <i>Ranged Weapon Attack: </i>
      </xsl:if>
      <xsl:copy-of select="."/>
    </div>
  </xsl:template>

</xsl:stylesheet>
