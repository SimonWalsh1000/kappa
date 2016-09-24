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

ActiveRecord::Schema.define(version: 20160917164738) do

  create_table "scores", force: :cascade do |t|
    t.integer  "case_id"
    t.integer  "patient_id"
    t.integer  "user_id"
    t.string   "dx1"
    t.string   "dx2"
    t.string   "dx3"
    t.string   "dx4"
    t.string   "dx5"
    t.integer  "dxcon1"
    t.integer  "dxcon2"
    t.integer  "dxcon3"
    t.integer  "dxcon4"
    t.integer  "dxcon5"
    t.string   "job"
    t.string   "description"
    t.integer  "experience"
    t.string   "institution"
    t.string   "fellowship"
    t.string   "meeting_type"
    t.string   "ipf_diagnostic_approach"
    t.string   "mdt_frequency"
    t.string   "ipf_number_cases"
    t.string   "imaging"
    t.string   "histopathology"
    t.integer  "ipf"
    t.integer  "hp"
    t.integer  "nsip"
    t.integer  "ctd"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "country"
    t.string   "fname"
    t.string   "lname"
    t.string   "status"
    t.string   "biopsy"
    t.string   "cryo"
    t.integer  "fibroticbehaviour"
    t.integer  "treatment_required"
    t.integer  "limitedbehaviour"
    t.integer  "reversiblebehaviour"
    t.string   "mgt"
    t.string   "comment"
  end

end
