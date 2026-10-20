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

ActiveRecord::Schema[8.1].define(version: 2026_10_20_155433) do
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
    t.string "locale"
    t.integer "mode"
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

  create_table "merchant_sync_steps", force: :cascade do |t|
    t.integer "step", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.json "payload_error", default: {}, null: false
    t.integer "merchant_sync_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_sync_id"], name: "index_merchant_sync_steps_on_merchant_sync_id"
  end

  create_table "merchant_syncs", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "mode", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "instigator", default: 0, null: false
    t.integer "added_merchants_count", default: 0, null: false
    t.integer "updated_merchants_count", default: 0, null: false
    t.integer "soft_deleted_merchants_count", default: 0, null: false
    t.json "payload_added_merchants", default: {}, null: false
    t.json "payload_before_updated_merchants", default: {}, null: false
    t.json "payload_updated_merchants", default: {}, null: false
    t.json "payload_soft_deleted_merchants", default: {}, null: false
    t.json "payload_countries", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
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
    t.string "contact_nostr"
    t.boolean "silver", default: false, null: false
    t.boolean "gold", default: false, null: false
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

  create_table "nostr_events", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "event_identifier"
    t.json "payload_event", default: {}, null: false
    t.json "payload_response", default: {}, null: false
    t.string "nostr_eventable_type", null: false
    t.integer "nostr_eventable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_identifier"], name: "index_nostr_events_on_event_identifier", unique: true
    t.index ["identifier"], name: "index_nostr_events_on_identifier", unique: true
    t.index ["nostr_eventable_type", "nostr_eventable_id"], name: "index_nostr_events_on_nostr_eventable"
  end

  create_table "rails_pulse_deployments", force: :cascade do |t|
    t.string "revision", null: false
    t.datetime "started_at", null: false
    t.datetime "finished_at"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["revision"], name: "index_rails_pulse_deployments_on_revision"
    t.index ["started_at"], name: "index_rails_pulse_deployments_on_started_at"
  end

  create_table "rails_pulse_exception_groups", force: :cascade do |t|
    t.string "fingerprint", null: false
    t.string "exception_class", null: false
    t.string "location"
    t.text "message"
    t.datetime "first_seen_at", null: false
    t.datetime "last_seen_at", null: false
    t.integer "occurrence_count", default: 0, null: false
    t.string "status", default: "open", null: false
    t.datetime "resolved_at"
    t.boolean "preserve", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exception_class"], name: "index_rp_exception_groups_on_class"
    t.index ["fingerprint"], name: "index_rp_exception_groups_on_fingerprint", unique: true
    t.index ["last_seen_at"], name: "index_rp_exception_groups_on_last_seen_at"
    t.index ["status"], name: "index_rp_exception_groups_on_status"
  end

  create_table "rails_pulse_exception_occurrences", force: :cascade do |t|
    t.integer "exception_group_id", null: false
    t.string "exception_class", null: false
    t.text "message"
    t.text "backtrace"
    t.string "request_url"
    t.string "request_method"
    t.string "environment"
    t.string "deploy_sha"
    t.text "request_params"
    t.datetime "occurred_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exception_group_id"], name: "index_rp_exception_occurrences_on_group_id"
    t.index ["occurred_at"], name: "index_rp_exception_occurrences_on_occurred_at"
  end

  create_table "rails_pulse_job_runs", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "run_id", null: false
    t.decimal "duration", precision: 15, scale: 6
    t.string "status", null: false
    t.string "error_class"
    t.text "error_message"
    t.integer "attempts", default: 0, null: false
    t.datetime "occurred_at", null: false
    t.datetime "enqueued_at"
    t.text "arguments"
    t.string "adapter"
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "occurred_at"], name: "index_rails_pulse_job_runs_on_job_and_occurred"
    t.index ["job_id", "status"], name: "index_rails_pulse_job_runs_on_job_and_status"
    t.index ["job_id"], name: "index_rails_pulse_job_runs_on_job_id"
    t.index ["occurred_at"], name: "index_rails_pulse_job_runs_on_occurred_at"
    t.index ["run_id"], name: "index_rails_pulse_job_runs_on_run_id", unique: true
    t.index ["status"], name: "index_rails_pulse_job_runs_on_status"
  end

  create_table "rails_pulse_jobs", force: :cascade do |t|
    t.string "name", null: false
    t.string "queue_name"
    t.text "description"
    t.integer "runs_count", default: 0, null: false
    t.integer "failures_count", default: 0, null: false
    t.integer "retries_count", default: 0, null: false
    t.decimal "avg_duration", precision: 15, scale: 6
    t.decimal "p95_duration", precision: 15, scale: 6
    t.decimal "p99_duration", precision: 15, scale: 6
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rails_pulse_jobs_on_name", unique: true
    t.index ["queue_name"], name: "index_rails_pulse_jobs_on_queue"
    t.index ["runs_count"], name: "index_rails_pulse_jobs_on_runs_count"
  end

  create_table "rails_pulse_operations", force: :cascade do |t|
    t.integer "request_id"
    t.integer "job_run_id"
    t.integer "query_id"
    t.string "operation_type", null: false
    t.string "label", null: false
    t.decimal "duration", precision: 15, scale: 6, null: false
    t.string "codebase_location"
    t.float "start_time", default: 0.0, null: false
    t.datetime "occurred_at", null: false
    t.integer "row_count"
    t.boolean "cache_hit"
    t.text "actual_sql"
    t.text "repeated_query_group"
    t.integer "repetition_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "query_id"], name: "idx_operations_for_aggregation"
    t.index ["job_run_id"], name: "index_rails_pulse_operations_on_job_run_id"
    t.index ["occurred_at", "duration", "operation_type"], name: "index_rails_pulse_operations_on_time_duration_type"
    t.index ["operation_type"], name: "index_rails_pulse_operations_on_operation_type"
    t.index ["query_id", "duration", "occurred_at"], name: "index_rails_pulse_operations_query_performance"
    t.index ["query_id", "occurred_at"], name: "index_rails_pulse_operations_on_query_and_time"
    t.index ["request_id"], name: "index_rails_pulse_operations_on_request_id"
  end

  create_table "rails_pulse_queries", force: :cascade do |t|
    t.string "hashed_sql", limit: 32, null: false
    t.text "normalized_sql", null: false
    t.datetime "analyzed_at"
    t.text "explain_plan"
    t.text "issues"
    t.text "metadata"
    t.text "query_stats"
    t.text "backtrace_analysis"
    t.text "index_recommendations"
    t.text "n_plus_one_analysis"
    t.text "suggestions"
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_sql"], name: "index_rails_pulse_queries_on_hashed_sql", unique: true
  end

  create_table "rails_pulse_requests", force: :cascade do |t|
    t.integer "route_id", null: false
    t.string "method"
    t.decimal "duration", precision: 15, scale: 6, null: false
    t.integer "status", null: false
    t.boolean "is_error", default: false, null: false
    t.string "request_uuid", null: false
    t.string "controller_action"
    t.datetime "occurred_at", null: false
    t.text "tags"
    t.integer "response_size_bytes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "route_id"], name: "idx_requests_for_aggregation"
    t.index ["occurred_at"], name: "index_rails_pulse_requests_on_occurred_at"
    t.index ["request_uuid"], name: "index_rails_pulse_requests_on_request_uuid", unique: true
    t.index ["route_id", "occurred_at"], name: "index_rails_pulse_requests_on_route_id_and_occurred_at"
    t.index ["route_id"], name: "index_rails_pulse_requests_on_route_id"
  end

  create_table "rails_pulse_routes", force: :cascade do |t|
    t.text "http_methods", null: false
    t.string "path", null: false
    t.text "tags"
    t.string "controller_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_action", "path"], name: "index_rails_pulse_routes_on_controller_action_and_path", unique: true
    t.index ["path"], name: "index_rails_pulse_routes_on_path"
    t.index ["path"], name: "index_rails_pulse_routes_on_path_without_action", unique: true, where: "controller_action IS NULL"
  end

  create_table "rails_pulse_summaries", force: :cascade do |t|
    t.datetime "period_start", null: false
    t.datetime "period_end", null: false
    t.string "period_type", null: false
    t.string "summarizable_type", null: false
    t.integer "summarizable_id", null: false
    t.integer "count", default: 0, null: false
    t.float "avg_duration"
    t.float "min_duration"
    t.float "max_duration"
    t.float "p50_duration"
    t.float "p95_duration"
    t.float "p99_duration"
    t.float "total_duration"
    t.float "stddev_duration"
    t.integer "error_count", default: 0
    t.integer "success_count", default: 0
    t.integer "status_2xx", default: 0
    t.integer "status_3xx", default: 0
    t.integer "status_4xx", default: 0
    t.integer "status_5xx", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_rails_pulse_summaries_on_created_at"
    t.index ["period_start"], name: "index_rails_pulse_summaries_on_period_start"
    t.index ["period_type", "period_start"], name: "index_rails_pulse_summaries_on_period"
    t.index ["summarizable_id"], name: "index_rails_pulse_summaries_on_summarizable_id"
    t.index ["summarizable_type", "summarizable_id", "period_type", "period_start"], name: "idx_pulse_summaries_unique", unique: true
    t.index ["summarizable_type", "summarizable_id"], name: "index_rails_pulse_summaries_on_summarizable"
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
    t.string "email_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 3, null: false
    t.boolean "enabled", default: false, null: false
    t.string "password_digest"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
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
  add_foreign_key "merchant_sync_steps", "merchant_syncs"
  add_foreign_key "rails_pulse_exception_occurrences", "rails_pulse_exception_groups", column: "exception_group_id"
  add_foreign_key "rails_pulse_job_runs", "rails_pulse_jobs", column: "job_id"
  add_foreign_key "rails_pulse_operations", "rails_pulse_job_runs", column: "job_run_id"
  add_foreign_key "rails_pulse_operations", "rails_pulse_queries", column: "query_id"
  add_foreign_key "rails_pulse_operations", "rails_pulse_requests", column: "request_id"
  add_foreign_key "rails_pulse_requests", "rails_pulse_routes", column: "route_id"
  add_foreign_key "sessions", "users"
end
