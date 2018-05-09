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

ActiveRecord::Schema.define(version: 2014_08_12_173537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", id: :serial, force: :cascade do |t|
    t.string "device_type", limit: 255
    t.string "serial_number", limit: 255
    t.string "district_tag", limit: 255
    t.integer "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "checked_in"
    t.index ["student_id"], name: "index_devices_on_student_id"
  end

  create_table "finances", id: :serial, force: :cascade do |t|
    t.boolean "charge"
    t.decimal "amount"
    t.string "note", limit: 255
    t.integer "student_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["student_id"], name: "index_finances_on_student_id"
    t.index ["user_id"], name: "index_finances_on_user_id"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.string "note", limit: 255
    t.integer "device_id"
    t.integer "student_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["device_id"], name: "index_notes_on_device_id"
    t.index ["student_id"], name: "index_notes_on_student_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "id_number", limit: 255
    t.integer "grade_level"
    t.boolean "active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "current_school", limit: 255
    t.string "parent_1_name", limit: 255
    t.string "parent_1_phone", limit: 255
    t.string "parent_2_name", limit: 255
    t.string "parent_2_phone", limit: 255
    t.string "insurance_expiration", limit: 255
    t.string "email", limit: 255
    t.string "parent_1_email", limit: 255
    t.string "parent_2_email", limit: 255
    t.string "policy_number", limit: 255
    t.string "home_phone", limit: 255
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
