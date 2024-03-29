# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_31_143932) do

  create_table "logs", charset: "utf8mb4", force: :cascade do |t|
    t.string "category"
    t.string "loggable_type"
    t.integer "loggable_id"
    t.string "file"
    t.text "content"
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category"], name: "index_logs_on_category"
    t.index ["loggable_id"], name: "index_logs_on_loggable_id"
    t.index ["loggable_type"], name: "index_logs_on_loggable_type"
  end

  create_table "queued_tasks", charset: "utf8mb4", force: :cascade do |t|
    t.string "klass"
    t.text "data"
    t.boolean "locked"
    t.integer "weight"
    t.integer "attempts"
    t.datetime "perform_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["locked"], name: "index_queued_tasks_on_locked"
    t.index ["weight"], name: "index_queued_tasks_on_weight"
  end

  create_table "search_indices", charset: "utf8mb4", force: :cascade do |t|
    t.string "searchable_type"
    t.integer "searchable_id"
    t.string "namespace"
    t.string "locale"
    t.string "name"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["locale", "name"], name: "index_search_indices_on_locale_and_name"
    t.index ["locale"], name: "index_search_indices_on_locale"
    t.index ["searchable_type", "searchable_id"], name: "index_search_indices_on_searchable_type_and_searchable_id"
  end

  create_table "search_modules", charset: "utf8mb4", force: :cascade do |t|
    t.string "klass"
    t.boolean "searchable"
    t.integer "weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["klass", "searchable"], name: "index_search_modules_on_klass_and_searchable"
  end

end
