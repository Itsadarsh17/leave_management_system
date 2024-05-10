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

ActiveRecord::Schema.define(version: 2024_05_10_062631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leave_applications", force: :cascade do |t|
    t.text "reason"
    t.date "start_date"
    t.date "end_date"
    t.integer "leave_type", default: 0
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "approver_id"
    t.bigint "backup_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approver_id"], name: "index_leave_applications_on_approver_id"
    t.index ["backup_user_id"], name: "index_leave_applications_on_backup_user_id"
    t.index ["user_id"], name: "index_leave_applications_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.decimal "leave_balance", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "role_id", default: 1
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "leave_applications", "users"
  add_foreign_key "leave_applications", "users", column: "approver_id"
  add_foreign_key "leave_applications", "users", column: "backup_user_id"
  add_foreign_key "users", "roles"
end
