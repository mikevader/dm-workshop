class FreeForm < Card
  acts_as_taggable

  validates :icon, presence: true
  validates :color, presence: true

  def replicate
    replica = super

    replica
  end

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = icon
    data.color = color

    unless contents.nil?
      contents.lines.map(&:strip).each do |line|
        parts = line.split('|').map(&:strip)

        element_name = parts.first
        element_params = parts.drop(1)

        case element_name
          when 'subtitle'
            data.add_subtitle(element_params)
          when 'rule'
            data.add_rule
          when 'property'
            data.add_property element_params
          when 'description'
            data.add_description element_params
          when 'text'
            data.add_text element_params
          when 'boxes'
            data.add_boxes element_params
          when 'fill'
            data.add_fill element_params
          when 'subsection'
            data.add_subsection element_params
          when 'bullet'
            data.add_bullet element_params
          else
            data.add_unknown element_name
        end
      end
    end

    return data
  end

  def self.new_search_builder
    builder = SearchBuilder.new do
      configure_field 'name', 'cards.name'
      configure_field 'type', 'cards.type'
      configure_tag 'tags', FreeForm
    end
    return builder
  end
end