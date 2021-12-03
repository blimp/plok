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

ActiveRecord::Schema.define(version: 2021_12_03_103118) do

  create_table "logs", charset: "utf8mb4", force: :cascade do |t|
    t.string "category"
    t.string "loggable_type"
    t.integer "loggable_id"
    t.string "file"
    t.text "content"
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
  end

end
