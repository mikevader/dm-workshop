# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150910004652) do

  create_table "attributes", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attributes", ["item_id"], name: "index_attributes_on_item_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cssclass"
  end

  add_index "categories", ["name"], name: "index_categories_on_name"

  create_table "hero_classes", force: :cascade do |t|
    t.string   "name"
    t.string   "cssclass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hero_classes", ["name"], name: "index_hero_classes_on_name"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "rarity_id"
    t.boolean  "attunement"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "cssclass"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id"
  add_index "items", ["name"], name: "index_items_on_name"
  add_index "items", ["rarity_id"], name: "index_items_on_rarity_id"
  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "properties", ["item_id"], name: "index_properties_on_item_id"

  create_table "rarities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rarities", ["name"], name: "index_rarities_on_name"

  create_table "spellclasses", force: :cascade do |t|
    t.integer  "spell_id"
    t.integer  "hero_class_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "spellclasses", ["hero_class_id"], name: "index_spellclasses_on_hero_class_id"
  add_index "spellclasses", ["spell_id", "hero_class_id"], name: "index_spellclasses_on_spell_id_and_hero_class_id", unique: true
  add_index "spellclasses", ["spell_id"], name: "index_spellclasses_on_spell_id"

  create_table "spells", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.string   "school"
    t.string   "classes"
    t.string   "casting_time"
    t.string   "range"
    t.string   "components"
    t.string   "duration"
    t.text     "short_description"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "picture"
    t.string   "athigherlevel"
    t.boolean  "concentration"
  end

  add_index "spells", ["level"], name: "index_spells_on_level"
  add_index "spells", ["name"], name: "index_spells_on_name"
  add_index "spells", ["user_id", "created_at"], name: "index_spells_on_user_id_and_created_at"
  add_index "spells", ["user_id"], name: "index_spells_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
