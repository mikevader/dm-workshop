module MonstersHelper

  def skill_modifier(monster, skill)
    raise ArgumentError if monster.nil?
    raise ArgumentError if skill.nil?
    
    modifier = case skill.ability.downcase
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
    
    modifier += monster.bonus if monster.skills.include? skill
    
    return modifier
  end
end
