module ColumnsHelper
  def columns_definition klass = nil
    case klass
      when 'cards'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Icon', field: lambda { |card| card.icon }},
         {title: 'Color', field: lambda { |card| card.color }}]
      when 'spells'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Level', field: lambda { |card| card.level }},
         {title: 'School', field: lambda { |card| card.school }}]
      when 'monsters'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Type', field: lambda { |card| "#{card.size} #{card.monster_type}" }},
         {title: 'CR', field: lambda { |card| Monster.challenge_pretty(card.challenge) }}]
      when 'items'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Category', field: lambda { |card| card.category.name }},
         {title: 'Rarity', field: lambda { |card| card.rarity.name }}]
      else
        [{title: 'Name', field: lambda { |card| card.name }}]
    end
  end
end