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

ActiveRecord::Schema.define(version: 20151211150055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "directions", force: :cascade do |t|
    t.integer  "recipe_id",  null: false
    t.string   "step",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ingredients", ["name"], name: "index_ingredients_on_name", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "recipe_categories", force: :cascade do |t|
    t.integer  "recipe_id",   null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer  "recipe_id",     null: false
    t.integer  "ingredient_id", null: false
    t.float    "amount",        null: false
    t.string   "unit"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.integer  "user_id",               null: false
    t.string   "name",                  null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "source_name"
    t.string   "source_url"
    t.string   "source_image_url"
    t.string   "my_image_file_name"
    t.string   "my_image_content_type"
    t.integer  "my_image_file_size"
    t.datetime "my_image_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "auth_token"
  end

end
