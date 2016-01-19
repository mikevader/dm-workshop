class CardExport

  def initialize
  end

  def load_monsters(monsters)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.cards {
        xml.monsters {
          monsters.each do |monster|
            xml.monster {
              xml.cite monster.cite
              xml.name monster.name
              xml.type_ monster.monster_type
              xml.stats {
                xml.proficiency monster.bonus
                xml.size monster.size
                xml.ac monster.armor_class
                xml.hp monster.hit_points
                xml.speed monster.speed
                xml.abilities(str: monster.strength, dex: monster.dexterity, con: monster.constitution, int: monster.intelligence, wis: monster.wisdom, cha: monster.charisma)

                unless monster.saving_throws.empty?
                  xml.savingThrows {
                    monster.saving_throws.each do |ability|
                      xml.parent[ability] = ''
                    end
                  }
                end

                unless monster.skills.empty?
                  xml.skills {
                    monster.skills.each do |skill|
                      xml.skill(name: skill.name)
                    end
                  }
                end

                unless monster.damage_vulnerabilities.empty?
                  xml.dmgVulnerability {
                    monster.damage_vulnerabilities.each do |dmg|
                      xml.send dmg
                    end
                  }
                end
                unless monster.damage_resistances.empty?
                  xml.dmgResistance {
                    monster.damage_resistances.each do |dmg|
                      xml.send dmg
                    end
                  }
                end
                unless monster.damage_immunities.empty?
                  xml.dmgImmunity {
                    monster.damage_immunities.each do |dmg|
                      xml.send dmg
                    end
                  }
                end
                unless monster.cond_immunities.empty?
                  xml.condImmunity {
                    monster.cond_immunities.each do |cond|
                      xml.send cond
                    end
                  }
                end

                unless monster.senses.blank?
                  xml.senses {
                    monster.senses.split(', ').each do |sense_str|
                      sense = sense_str.split(': ')
                      xml.sense(name: sense[0]) {
                        xml.text sense[1]
                      }
                    end
                  }
                end
                xml.languages monster.languages
                xml.cr "#{Monster.challenge_pretty(monster.challenge)} (#{Monster.xp_for_cr(monster.challenge)} XP)"
              }

              unless monster.traits.empty?
                xml.traits {
                  monster.traits.each do |trait|
                    xml.trait(name: trait.title) {
                      xml << "\n#{'  '*5}#{trait.description.gsub(/\<br\> /, "<br>\n")}\n#{'  '*4}"
                    }
                  end
                }
              end

              xml.actions {
                monster.actions.each do |action|
                  if action.description.start_with? '<i>Melee'
                    xml.meleeWeaponAttack(name: action.title) {
                      xml << "\n#{'  '*5}#{action.description[28..-1]}\n#{'  '*4}"
                    }
                  elsif action.description.start_with? '<i>Ranged'
                    xml.rangedWeaponAttack(name: action.title) {
                      xml << "\n#{'  '*5}#{action.description[29..-1]}\n#{'  '*4}"
                    }
                  else
                    xml.action(name: action.title) {
                      xml << "\n#{'  '*5}#{action.description}\n#{'  '*4}"
                    }
                  end
                end
              }
            }
          end
        }
      }
    end

    return builder.to_xml(indent: 2)
  end

  def load_spells(spells)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.cards {
        xml.spells {
          spells.each do |spell|
            xml.spell {
              #xml.cite spell.cite
              xml.name spell.name
              xml.type_ "#{spell.level.ordinalize}-level #{spell.school}"
              xml.classes {
                spell.hero_classes.each do |class_|
                  xml.class_ class_.name
                end
              }
              xml.castingTime spell.casting_time
              xml.range spell.range
              xml.components spell.components
              xml.duration spell.duration
              xml.shortDescription {
                xml << "\n#{'  '*4 + spell.short_description + "\n" unless spell.short_description.blank?}#{'  '*3}"
              }
              xml.atHigherLevel spell.athigherlevel
              xml.description {
                xml << "\n#{'  '*4}#{spell.description}\n#{'  '*3}"
              }
            }
          end
        }
      }
    end

    builder.to_xml(indent: 2)
  end

  def load_items(items)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.cards {
        xml.items {
          items.each do |item|
            xml.item {
              xml.name item.name
              xml.cite item.cite
              xml.type_ item.category.name
              xml.rarity item.rarity.name
              xml.requiresAttunement item.attunement ? 'yes' : 'no'
              xml.description {
                xml << "\n#{'  '*4}#{item.description}\n#{'  '*3}"
              }
            }
          end
        }
      }
    end

    builder.to_xml(indent: 2)
  end

=begin
    t.string   "name"
    t.string   "icon"
    t.string   "color"
    t.text     "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "badges"
=end
  def load_cards(cards)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.cards {
        xml.cards {
          cards.each do |card|
            xml.card {
              xml.name card.name
              xml.icon card.icon
              xml.color card.color
              xml.badges card.badges
              xml.contents card.contents
            }
          end
        }
      }
    end

    builder.to_xml(indent: 2)
  end
end
