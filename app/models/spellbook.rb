class Spellbook < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :spells, -> {reorder('level asc, name asc')}, join_table: :spellbooks_spells

  accepts_nested_attributes_for :spells, reject_if: proc { |spell_entry| spell_entry['spell_id'].blank? }, allow_destroy: true
end
