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

ActiveRecord::Schema.define(version: 20140321172024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: true do |t|
    t.string   "device_type"
    t.string   "serial_number"
    t.string   "district_tag"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["student_id"], name: "index_devices_on_student_id", using: :btree

  create_table "finances", force: true do |t|
    t.boolean  "charge"
    t.decimal  "amount"
    t.string   "note"
    t.integer  "student_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "finances", ["student_id"], name: "index_finances_on_student_id", using: :btree
  add_index "finances", ["user_id"], name: "index_finances_on_user_id", using: :btree

  create_table "notes", force: true do |t|
    t.string   "note"
    t.integer  "device_id"
    t.integer  "student_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["device_id"], name: "index_notes_on_device_id", using: :btree
  add_index "notes", ["student_id"], name: "index_notes_on_student_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "id_number"
    t.integer  "grade_level"
    t.boolean  "active",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "insurance"
    t.string   "current_school"
    t.string   "parent_1_name"
    t.string   "parent_1_phone"
    t.string   "parent_2_name"
    t.string   "parent_2_phone"
    t.string   "insurance_expiration"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
