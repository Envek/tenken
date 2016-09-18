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

ActiveRecord::Schema.define(version: 20160918101354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "checks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "site_id",          null: false
    t.datetime "started_at",       null: false
    t.datetime "finished_at",      null: false
    t.boolean  "success",          null: false, comment: "Whether this check considered successful"
    t.integer  "response_code",                 comment: "HTTP response_code"
    t.jsonb    "response_headers",              comment: "A key-value object of received HTTP headers"
    t.text     "details",                       comment: "Technical details for debugging"
    t.datetime "created_at",       null: false
    t.index ["site_id", "created_at"], name: "index_checks_on_site_id_and_created_at", order: {"created_at"=>:desc}, using: :btree
    t.index ["site_id"], name: "index_checks_on_site_id", using: :btree
  end

  create_table "sites", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "uri",        null: false, comment: "Full URI that will be checked (with protocol and path)"
    t.string   "name",                    comment: "Short name displayed to humans"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "checks", "sites", on_update: :cascade, on_delete: :cascade
end
