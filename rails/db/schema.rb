# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_14_120430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.string "locale"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "theme_id"
  end

  create_table "curriculum_stories", force: :cascade do |t|
    t.bigint "curriculum_id", null: false
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_order"
    t.index ["curriculum_id"], name: "index_curriculum_stories_on_curriculum_id"
    t.index ["story_id"], name: "index_curriculum_stories_on_story_id"
  end

  create_table "curriculums", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_curriculums_on_user_id"
  end

  create_table "media_links", force: :cascade do |t|
    t.string "url"
    t.bigint "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_media_links_on_story_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "type_of_place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "long", precision: 10, scale: 6
    t.string "region"
    t.string "description"
    t.integer "community_id"
  end

  create_table "places_stories", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "place_id", null: false
    t.index ["story_id", "place_id"], name: "index_places_stories_on_story_id_and_place_id"
  end

  create_table "speaker_stories", force: :cascade do |t|
    t.bigint "speaker_id", null: false
    t.bigint "story_id", null: false
  end

  create_table "speakers", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "birthdate"
    t.integer "birthplace_id"
    t.string "speaker_community"
    t.integer "community_id"
    t.index ["birthplace_id"], name: "index_speakers_on_birthplace_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "permission_level"
    t.datetime "date_interviewed"
    t.string "language"
    t.integer "interview_location_id"
    t.integer "interviewer_id"
    t.integer "community_id"
    t.string "topic"
  end

  create_table "themes", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mapbox_style_url"
    t.string "mapbox_access_token"
    t.boolean "mapbox_3d", default: false
    t.decimal "center_lat", precision: 10, scale: 6
    t.decimal "center_long", precision: 10, scale: 6
    t.decimal "sw_boundary_lat", precision: 10, scale: 6
    t.decimal "sw_boundary_long", precision: 10, scale: 6
    t.decimal "ne_boundary_lat", precision: 10, scale: 6
    t.decimal "ne_boundary_long", precision: 10, scale: 6
    t.decimal "zoom", precision: 10, scale: 6
    t.decimal "pitch", precision: 10, scale: 6
    t.decimal "bearing", precision: 10, scale: 6
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.integer "community_id"
    t.boolean "super_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "curriculum_stories", "curriculums"
  add_foreign_key "curriculum_stories", "stories"
  add_foreign_key "curriculums", "users"
end
