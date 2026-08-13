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

ActiveRecord::Schema[8.1].define(version: 2026_08_13_153117) do
  create_table "books", force: :cascade do |t|
    t.string "author", null: false
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer "book_id", null: false
    t.datetime "checked_out_at", null: false
    t.datetime "created_at", null: false
    t.date "due_date"
    t.datetime "returned_at"
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_checkouts_on_book_id"
    t.index ["book_id"], name: "index_checkouts_on_book_id_when_open", unique: true, where: "returned_at IS NULL"
  end

  add_foreign_key "checkouts", "books"
end
