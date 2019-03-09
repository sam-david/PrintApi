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

ActiveRecord::Schema.define(version: 2019_03_09_045228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jobs", force: :cascade do |t|
    t.bigint "component_id"
    t.string "gcode_title"
    t.string "display_title"
    t.integer "priority"
    t.string "slicer_profile"
    t.float "estimated_print_time"
    t.float "actual_filament_length"
    t.float "estimated_filament_length"
    t.float "filament_weight"
    t.integer "build_time_hours"
    t.integer "build_time_minutes"
    t.datetime "sliced_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "slicer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_jobs_on_component_id"
  end

  create_table "print_logs", force: :cascade do |t|
    t.bigint "job_id"
    t.float "tool_temp"
    t.float "bed_temp"
    t.float "filament_length"
    t.float "estimated_total_print_time"
    t.integer "print_time"
    t.integer "print_time_left"
    t.float "completion_percentage"
    t.datetime "logged_at"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_print_logs_on_job_id"
  end

end
