require 'retry'

# This service is responsible to fetch merchants map data from
# the Overpass API.
class FetchMerchants < ApplicationService
  include Rails.application.routes.url_helpers

  RETRYABLE_ERRORS = [
    HTTParty::Error, Timeout, Net::OpenTimeout, Net::ReadTimeout
  ].freeze

  attr_reader :instigator

  def initialize(instigator = :task)
    @instigator = instigator
    @current_features = Merchant.pluck(:raw_feature)
    @logs = []
  end

  def prepare
    @merchant_sync = MerchantSync.find_or_create_by!(
      status: :pending,
      instigator: instigator
    ) do |merchant_sync|
      merchant_sync.started_at = Time.current
    end

    @merchant_sync.update!(process_logs: @logs)
  end

  def call
    @logs << { mode: 'info', message: 'Calling Overpass API to fetch data', timestamp: Time.current.to_i }
    @merchant_sync.update!(process_logs: @logs)

    Merchant.transaction do
      response = Retry.on(*RETRYABLE_ERRORS) do
        OverpassAPI.new.fetch_merchants
      end

      @logs << { mode: 'info', message: 'Converting JSON to GeoJSON', timestamp: Time.current.to_i }
      @merchant_sync.update!(process_logs: @logs)

      geojson = JSONToGeoJSON.call(response.parsed_response)

      @geojson_merchant_ids = geojson['features'].pluck('id')

      @logs << { mode: 'info', message: 'Upserting data to database', timestamp: Time.current.to_i }
      @merchant_sync.broadcast_admin_replace_process_logs

      upsert_merchants_to_database(geojson)

      @logs << { mode: 'info', message: 'Attaching JSON file to most recent record', timestamp: Time.current.to_i }
      @merchant_sync.broadcast_admin_replace_process_logs

      @merchant_sync.raw_json.attach(
        io: StringIO.new(geojson.to_s),
        filename: "overpass_merchants_#{Time.current.to_fs(:number)}.json",
        content_type: 'application/json'
      )

      # As we are in a transaction, we cannot use
      # auto model broadcast.
      @merchant_sync.update!(process_logs: @logs)
    end

    @logs << { mode: 'info', message: 'Checking removed merchants from OSM', timestamp: Time.current.to_i }
    @logs << { mode: 'info', message: 'Notifying to Github issue', timestamp: Time.current.to_i }
    @merchant_sync.update!(process_logs: @logs)

    I18n.with_locale(I18n.default_locale) do
      Merchants::CheckAndReportRemovedOnOSM.call(@geojson_merchant_ids)
    end

    @logs << { mode: 'info', message: 'Reactivating legit soft-deleted merchants', timestamp: Time.current.to_i }
    @merchant_sync.update!(process_logs: @logs)

    Merchants::CheckAndReactivate.call(@geojson_merchant_ids)

    @logs << { mode: 'info', message: "Assigning country to merchants that don't have one", timestamp: Time.current.to_i }
    @merchant_sync.update!(process_logs: @logs)

    payload_countries = Merchants::AssignCountry.call

    ended_at = Time.current

    added_merchants = Merchant.where(created_at: @merchant_sync.started_at..ended_at)
    soft_deleted_merchants = Merchant.where(deleted_at: @merchant_sync.started_at..ended_at)
    updated_merchants = Merchant.where(updated_at: @merchant_sync.started_at..ended_at).where.not(id: [added_merchants.ids, soft_deleted_merchants.ids].flatten)

    if updated_merchants.any?
      updated_ids = updated_merchants.pluck(:original_identifier)
      features_previously_was = @current_features.select do |feature|
        feature['id'].in?(updated_ids)
      end

      @merchant_sync.payload_before_updated_merchants = features_previously_was
      @merchant_sync.payload_updated_merchants = updated_merchants.map(&:raw_feature)
    end

    @merchant_sync.update!(
      added_merchants_count: added_merchants.count,
      updated_merchants_count: updated_merchants.count,
      soft_deleted_merchants_count: soft_deleted_merchants.count,

      payload_added_merchants: added_merchants.map(&:raw_feature),
      payload_soft_deleted_merchants: soft_deleted_merchants.map(&:raw_feature),
      payload_countries: payload_countries
    )

    @logs << { mode: 'info', message: 'Purging previous JSON attachments on older records', timestamp: Time.current.to_i }
    @merchant_sync.update!(process_logs: @logs)

    @merchant_sync.purge_all_attachments_not_self

    if FeatureFlag.enabled?(:nostr) && @merchant_sync.added_merchants_count.positive?
      @logs << { mode: 'info', message: 'Publishing note to Nostr', timestamp: Time.current.to_i }
      @merchant_sync.update!(process_logs: @logs)

      I18n.with_locale(I18n.default_locale) do
        NostrPublisher.call(
          @merchant_sync, identifier: SecureRandom.uuid
        )
      end
    end

    @logs << { mode: 'success', message: 'End of synchronization ! 🎉', timestamp: Time.current.to_i }

    @merchant_sync.update!(
      status: :success,
      ended_at: ended_at,
      process_logs: @logs
    )

    # Broadcast with message scoped by locale
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        message = I18n.t('refresh_success', link: maps_url, scope: i18n_scope)

        Merchant.broadcast_flash(
          :notice, message, locale: locale, disappear: false
        )
      end
    end
  rescue StandardError => e
    @logs << { mode: 'error', message: "💥 #{e.message}", timestamp: Time.current.to_i }

    @merchant_sync.update!(
      status: :error,
      ended_at: Time.current,
      process_logs: @logs,
      payload_error: {
        exception: e.class.name,
        message: e.message,
        backtrace: e.backtrace
      }
    )

    Merchant.broadcast_flash(:alert, e.message)
  end

  def finish
    invalidate_cache
  end

  private

  # Store data into database within a batch insert
  def upsert_merchants_to_database(geojson)
    rows = geojson['features']
    data = rows.map do |feature|
      MerchantData.new(feature).json
    end.compact_blank

    Merchant.upsert_all(data, unique_by: :identifier)
  end

  def i18n_scope
    'merchants.refresh'
  end

  # Manually invalidate cache after Overpass sync
  # :nocov:
  def invalidate_cache
    return if Rails.env.test?

    merchants_cache = '%:MERCHANTS_FILTER:%'
    statistics_concern = "#{Rails.env}:concerns/statistics%"
    statistics_views = "#{Rails.env}:views/statistics%"

    records = SolidCache::Entry.where(
      'key LIKE ? OR key LIKE ? OR key LIKE ?',
      merchants_cache, statistics_concern, statistics_views
    )
    records.each(&:destroy)
  end
  # :nocov:
end
