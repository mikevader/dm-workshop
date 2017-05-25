module ColumnsHelper
  def columns_definition(klass, cards = nil)
    card_type = klass.classify

    unless %w(FreeForm Spell Monster Item).include? card_type or cards.nil?
      if cards.is_a? Array
        card_type = cards.first.class.name unless cards.empty?
      else
        card_type = cards.class.name
      end
    end

    columns = [{title: 'Name', field: lambda { |card| link_to card.name, card_path(card) }}]

    case card_type
      when 'FreeForm'
        columns.concat [{title: 'Icon', field: lambda { |card| card.icon }},
                        {title: 'Color', field: lambda { |card| card.color }}]
      when 'Spell'
        columns.concat [{title: 'Level', field: lambda { |card| card.level }},
                        {title: 'School', field: lambda { |card| card.school }}]
      when 'Monster'
        columns.concat [{title: 'Type', field: lambda { |card| "#{card.monster_size} #{card.monster_type}" }},
                        {title: 'CR', field: lambda { |card| Monster.challenge_pretty(card.challenge) }}]
      when 'Item'
        columns.concat [{title: 'Category', field: lambda { |card| card.category.name }},
                        {title: 'Rarity', field: lambda { |card| card.rarity.name }}]
    end

    columns
  end
end