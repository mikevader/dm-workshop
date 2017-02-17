class Spellbook < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :spells, join_table: :spellbooks_spells
end
