module ColumnsHelper
  def columns_definition(klass, cards = nil)
    card_type = klass.classify

    unless %w(Card Spell Monster Item).include? card_type or cards.nil?
      if cards.is_a? Array
        card_type = cards.first.class.name unless cards.empty?
      else
        card_type = cards.class.name
      end
    end

    case card_type
      when 'FreeForm'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Icon', field: lambda { |card| card.icon }},
         {title: 'Color', field: lambda { |card| card.color }}]
      when 'Spell'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Level', field: lambda { |card| card.level }},
         {title: 'School', field: lambda { |card| card.school }}]
      when 'Monster'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Type', field: lambda { |card| "#{card.size} #{card.monster_type}" }},
         {title: 'CR', field: lambda { |card| Monster.challenge_pretty(card.challenge) }}]
      when 'Item'
        [{title: 'Name', field: lambda { |card| card.name }},
         {title: 'Category', field: lambda { |card| card.category.name }},
         {title: 'Rarity', field: lambda { |card| card.rarity.name }}]
      else
        [{title: 'Name', field: lambda { |card| card.name }}]
    end
  end
end