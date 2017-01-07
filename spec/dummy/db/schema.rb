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

ActiveRecord::Schema.define(version: 20161212183042) do

  create_table "nd_employee_lookup_employees", force: :cascade do |t|
    t.text     "net_id"
    t.text     "nd_id"
    t.text     "last_name"
    t.text     "first_name"
    t.text     "middle_init"
    t.text     "primary_title"
    t.text     "employee_status"
    t.text     "home_orgn"
    t.text     "home_orgn_desc"
    t.integer  "pidm"
    t.text     "ecls_code"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "nd_workflow_details", force: :cascade do |t|
    t.integer  "nd_workflow_id"
    t.string   "detail_type"
    t.string   "detail_data"
    t.string   "detail_key"
    t.string   "detail_desc"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "nd_workflows", force: :cascade do |t|
    t.integer  "parent_record_id"
    t.string   "workflow_type"
    t.string   "auto_or_manual"
    t.string   "workflow_custom_type"
    t.string   "assigned_to_netid"
    t.string   "assigned_to_first_name"
    t.string   "assigned_to_last_name"
    t.text     "email_notes"
    t.boolean  "email_include_detail"
    t.text     "approval_notes"
    t.date     "approved_date"
    t.string   "approved_by_netid"
    t.string   "created_by_netid"
    t.string   "workflow_state"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "parent_records", force: :cascade do |t|
    t.string   "parent_desc"
    t.boolean  "nd_workflow_approval_available"
    t.boolean  "nd_workflow_include_email_detail_cb"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
