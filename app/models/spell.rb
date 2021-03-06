class Spell < Card
  acts_as_taggable

  default_scope -> { order(name: :asc) }
  mount_uploader :picture, PictureUploader

  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9 }
  validates :school, presence: true
  # validate :spell_unique_per_class
  validate :picture_size

  def replicate
    replica = super

    hero_classes.each do |hero_class|
      replica.hero_classes << hero_class
    end

    tag_list.each do |tag|
      replica.tag_list.add(tag)
    end

    replica
  end

  def subtitle
    if level == 0
      "#{school} cantrip"
    else
      "#{level.try(:ordinalize)}-level #{school}"
    end
  end

  def card_data(detailed = false)
    data = super(detailed)

    data.name = "#{name}#{' (Ritual)' if ritual?}"
    data.icon = "icon-white-book-#{level}"
    data.color = 'maroon'
    data.description = description
    data.badges = hero_classes.collect(&:cssclass)

    data.add_subtitle [subtitle]

    data.add_rule
    data.add_property ['Casting Time', casting_time]
    data.add_property ['Range', range]
    data.add_property ['Components', components]
    data.add_property ['Duration', duration]
    data.add_fill [2]

    if short_description.blank? || detailed
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

    errors.add(:picture, 'should be less than 5MB') if picture.size > 5.megabytes
  end

  # Validates the uniqueness of a spell in a class
  def spell_unique_per_class
    errors.add :spell, 'tried to add a class multiple times' if hero_classes.select { |c| hero_classes.select { |q| q == c }.size > 1 }.any?
  end

end
