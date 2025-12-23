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

ActiveRecord::Schema[8.1].define(version: 2025_12_23_051821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "batches", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_batches_on_course_id"
    t.index ["name"], name: "index_batches_on_name"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "school_id", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_courses_on_name"
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.datetime "created_at", null: false
    t.integer "progress"
    t.integer "status", default: 0, null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_enrollments_on_batch_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "progresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "enrollment_id", null: false
    t.integer "percentage"
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_progresses_on_enrollment_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_schools_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.integer "school_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["school_id"], name: "index_users_on_school_id"
  end

  add_foreign_key "batches", "courses"
  add_foreign_key "courses", "schools"
  add_foreign_key "enrollments", "batches"
  add_foreign_key "enrollments", "users", column: "student_id"
  add_foreign_key "progresses", "enrollments"
  add_foreign_key "users", "schools"
end
