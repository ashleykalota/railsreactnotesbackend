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

ActiveRecord::Schema[7.2].define(version: 2024_11_04_150644) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ambulance_requests", force: :cascade do |t|
    t.string "origin"
    t.string "destination"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ambulance_request_id", null: false
    t.decimal "amount"
    t.string "status"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ambulance_request_id"], name: "index_billings_on_ambulance_request_id"
    t.index ["user_id"], name: "index_billings_on_user_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
    t.string "phone_number"
    t.string "email"
    t.string "name"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "billings", "ambulance_requests"
  add_foreign_key "billings", "users"
  add_foreign_key "notes", "users"
end
