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

ActiveRecord::Schema[8.0].define(version: 2025_10_06_165850) do
  create_table "active_analytics_browsers_per_days", force: :cascade do |t|
    t.string "site", null: false
    t.string "name", null: false
    t.string "version", null: false
    t.date "date", null: false
    t.bigint "total", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "site", "name", "version"], name: "idx_on_date_site_name_version_eeccd0371c"
  end

  create_table "active_analytics_views_per_days", force: :cascade do |t|
    t.string "site", null: false
    t.string "page", null: false
    t.date "date", null: false
    t.bigint "total", default: 1, null: false
    t.string "referrer_host"
    t.string "referrer_path"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["date", "site", "page"], name: "index_active_analytics_views_per_days_on_date_and_site_and_page"
    t.index ["date", "site", "referrer_host", "referrer_path"], name: "index_views_per_days_on_date_site_referrer_host_referrer_path"
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "label"
    t.string "house_number"
    t.string "street"
    t.string "postcode"
    t.string "city"
    t.string "country"
    t.string "country_code"
    t.float "latitude"
    t.float "longitude"
    t.string "addressable_type", null: false
    t.integer "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
    t.index ["latitude", "longitude"], name: "index_addresses_on_latitude_and_longitude"
    t.index ["latitude"], name: "index_addresses_on_latitude"
    t.index ["longitude"], name: "index_addresses_on_longitude"
  end

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "locale"
    t.integer "mode"
    t.string "link_to_visit"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "token", null: false
    t.integer "requests_count", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token", unique: true
  end

  create_table "coin_wallets", force: :cascade do |t|
    t.integer "coin"
    t.string "public_address"
    t.boolean "enabled", default: true, null: false
    t.string "walletable_type", null: false
    t.integer "walletable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["walletable_type", "walletable_id"], name: "index_coin_wallets_on_walletable"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "rating", default: 0, null: false
    t.string "language", null: false
    t.string "pseudonym"
    t.string "commentable_type", null: false
    t.integer "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "flag_reason"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "contact_ways", force: :cascade do |t|
    t.integer "role"
    t.string "value"
    t.boolean "enabled", default: true, null: false
    t.string "contactable_type", null: false
    t.integer "contactable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contact_ways_on_contactable"
  end

  create_table "delivery_zones", force: :cascade do |t|
    t.integer "mode"
    t.string "value"
    t.string "city_name"
    t.string "department_code"
    t.string "region_code"
    t.string "country_code"
    t.boolean "enabled", default: true, null: false
    t.string "deliverable_type", null: false
    t.integer "deliverable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "continent_code"
    t.index ["city_name"], name: "index_delivery_zones_on_city_name"
    t.index ["continent_code"], name: "index_delivery_zones_on_continent_code"
    t.index ["country_code"], name: "index_delivery_zones_on_country_code"
    t.index ["deliverable_type", "deliverable_id"], name: "index_delivery_zones_on_deliverable"
    t.index ["department_code"], name: "index_delivery_zones_on_department_code"
    t.index ["region_code"], name: "index_delivery_zones_on_region_code"
  end

  create_table "directories", force: :cascade do |t|
    t.string "name_legacy"
    t.text "description_legacy"
    t.string "category"
    t.boolean "spotlight", default: false, null: false
    t.boolean "enabled", default: true, null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "merchant_id"
    t.integer "comments_count", default: 0, null: false
    t.index ["category"], name: "index_directories_on_category"
    t.index ["merchant_id"], name: "index_directories_on_merchant_id"
    t.index ["position"], name: "index_directories_on_position", unique: true
  end

  create_table "ecosystem_items", force: :cascade do |t|
    t.string "url"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "merchants", force: :cascade do |t|
    t.string "identifier"
    t.string "original_identifier"
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "house_number"
    t.string "street"
    t.string "postcode"
    t.string "city"
    t.string "country"
    t.string "full_address"
    t.string "website"
    t.string "email"
    t.string "phone"
    t.json "coins", default: [], null: false
    t.boolean "bitcoin", default: false, null: false
    t.boolean "lightning", default: false, null: false
    t.boolean "monero", default: false, null: false
    t.boolean "june", default: false, null: false
    t.boolean "contact_less", default: false, null: false
    t.string "icon", default: "shop", null: false
    t.string "category"
    t.json "geometry", default: {}, null: false
    t.json "raw_feature", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delivery", default: false, null: false
    t.string "delivery_zone"
    t.string "opening_hours"
    t.date "last_survey_on"
    t.string "contact_session"
    t.string "contact_signal"
    t.string "contact_matrix"
    t.string "contact_jabber"
    t.string "contact_telegram"
    t.string "contact_facebook"
    t.string "contact_instagram"
    t.string "contact_twitter"
    t.string "contact_youtube"
    t.string "contact_tiktok"
    t.string "contact_linkedin"
    t.string "contact_tripadvisor"
    t.boolean "ask_kyc"
    t.float "latitude"
    t.float "longitude"
    t.integer "comments_count", default: 0, null: false
    t.datetime "deleted_at"
    t.string "contact_odysee"
    t.string "contact_crowdbunker"
    t.string "contact_francelibretv"
    t.string "continent_code"
    t.index ["bitcoin"], name: "index_merchants_on_bitcoin"
    t.index ["category"], name: "index_merchants_on_category"
    t.index ["continent_code"], name: "index_merchants_on_continent_code"
    t.index ["country"], name: "index_merchants_on_country"
    t.index ["description"], name: "index_merchants_on_description"
    t.index ["full_address"], name: "index_merchants_on_full_address"
    t.index ["identifier"], name: "index_merchants_on_identifier", unique: true
    t.index ["june"], name: "index_merchants_on_june"
    t.index ["lightning"], name: "index_merchants_on_lightning"
    t.index ["monero"], name: "index_merchants_on_monero"
    t.index ["name"], name: "index_merchants_on_name"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.integer "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.integer "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 3, null: false
    t.boolean "enabled", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "weblinks", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.boolean "enabled", default: true, null: false
    t.string "weblinkable_type", null: false
    t.integer "weblinkable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weblinkable_type", "weblinkable_id"], name: "index_weblinks_on_weblinkable"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "directories", "merchants"
  add_foreign_key "sessions", "users"
end
