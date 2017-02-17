class Spell < Card
  acts_as_taggable
  has_and_belongs_to_many :spellbooks, join_table: :spellbooks_spells

  default_scope -> { order(name: :asc) }
  mount_uploader :picture, PictureUploader

  validates :level, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9}
  validates :school, presence: true
  # validate :spell_unique_per_class
  validate :picture_size

  def replicate
    replica = super

    hero_classes.each do |hero_class|
      replica.hero_classes << hero_class
    end

    self.tag_list.each do |tag|
      replica.tag_list.add(tag)
    end

    replica
  end

  def card_data
    data = super

    data.name = "#{name}#{' (Ritual)' if ritual?}"
    data.icon = "icon-white-book-#{level}"
    data.color = 'maroon'
    data.description = description

    hero_classes.each do |hero_class|
      data.badges << hero_class.cssclass
    end

    if level == 0
      data.add_subtitle ["#{school} cantrip"]
    else
      data.add_subtitle ["#{level.try(:ordinalize)}-level #{school}"]
    end

    data.add_rule
    data.add_property ['Casting Time', casting_time]
    data.add_property ['Range', range]
    data.add_property ['Components', components]
    data.add_property ['Duration', duration]
    data.add_fill [2]

    if short_description.blank?
      data.add_text [description] unless description.blank?
    else
      data.add_text [short_description]
    end

    unless athigherlevel.blank?
      data.add_subsection ['At higher levels']
      data.add_text [athigherlevel]
    end

    data
  end

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  # Validates the uniqueness of a spell in a class
  def spell_unique_per_class
    if hero_classes.select { |c| hero_classes.select { |q| q == c }.size > 1 }.any?
      errors.add :spell, 'tried to add a class multiple times'
    end
  end

end
