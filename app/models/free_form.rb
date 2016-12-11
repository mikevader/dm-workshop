class FreeForm < Card
  acts_as_taggable

  validates :icon, presence: true
  validates :color, presence: true

  def replicate
    replica = super

    replica
  end

  def card_data
    data = super

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
end