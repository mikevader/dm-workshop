class Item < Card
  acts_as_taggable
  belongs_to :category
  belongs_to :rarity
  has_many :properties, -> { order(position: :asc) }, dependent: :destroy, foreign_key: :card_id
  accepts_nested_attributes_for :properties, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true

  validates :category_id, presence: true
  validates :rarity_id, presence: true

  after_initialize do
    self.color = 'grey'
    self.icon = 'dirty-icon'
  end

  def replicate
    replica = super

    properties.each do |property|
      replica.properties << property.dup
    end

    replica
  end

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = category.cssclass unless category.nil?
    data.color = 'grey'
    data.description = description

    data.add_subtitle ["#{category.name}, #{rarity.name}"] unless category.nil? or rarity.nil?
    data.add_rule
    data.add_property ['attunement', attunement.to_s]
    properties.each do |property|
      data.add_property [property.name, property.value]
    end
    data.add_rule
    data.add_fill [2]
    data.add_text [description] unless description.blank?
    data.add_fill [3]

    return data
  end
end
