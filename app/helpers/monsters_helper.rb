module MonstersHelper

  def skill_modifier(monster, skill)
    raise ArgumentError if monster.nil?
    raise ArgumentError if skill.nil?
    
    modifier = ability_modifier(monster, skill.ability)
    
    modifier += monster.bonus if monster.skills.include? skill
    
    return modifier
  end
  
  def saving_throw_modifier(monster, saving_throw)
    modifier = ability_modifier(monster, saving_throw)
    
    modifier += monster.bonus if monster.saving_throws.include? saving_throw
    
    return modifier
  end
  
  def ability_modifier(monster, ability)
    case ability.downcase
    when 'str'
      monster.strength_modifier
    when 'dex'
      monster.dexterity_modifier
    when 'con'
      monster.constitution_modifier
    when 'int'
      monster.intelligence_modifier
    when 'wis'
      monster.wisdom_modifier
    when 'cha'
      monster.charisma_modifier
    end
  end
end
