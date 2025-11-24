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
  end

  def prepare
    @merchant_sync = MerchantSync.find_or_create_by!(
      status: :pending,
      instigator: instigator
    ) do |merchant_sync|
      merchant_sync.started_at = Time.current
    end

    @merchant_sync.merchant_sync_steps.create!(status: :success)
  end

  def call
    overpass_response = overpass_api_step
    geojson, geojson_merchant_ids = convert_to_geojson_step(overpass_response)

    save_data_step(geojson)
    attach_json_step(geojson)
    notify_github_step(geojson_merchant_ids)
    reactivate_disabled_step(geojson_merchant_ids)
    payload_countries = assign_country_step
    diff_change_step(payload_countries)
    purge_old_attachments_step

    if FeatureFlag.enabled?(:nostr) &&
       @merchant_sync.added_merchants_count.positive?
      publish_to_nostr_step
    end

    @merchant_sync.merchant_sync_steps.create!(step: :end_of_sync, status: :success)

    status = @merchant_sync.merchant_sync_steps.any?(&:error?) ? :success_with_error : :success
    @merchant_sync.update!(
      status: status,
      ended_at: Time.current
    )
  rescue StandardError => e
    @merchant_sync.mark_as_fail!

    Merchant.broadcast_flash(:alert, e.message)
  end

  def finish
    invalidate_cache

    # Broadcast with message scoped by locale
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        message = I18n.t('refresh_success', link: maps_url, scope: i18n_scope)

        Merchant.broadcast_flash(
          :notice, message, locale: locale, disappear: false
        )
      end
    end
  end

  private

  def overpass_api_step
    overpass_api_step = @merchant_sync.merchant_sync_steps.create!(step: :overpass_api)

    begin
      response = Retry.on(*RETRYABLE_ERRORS) do
        OverpassAPI.new.fetch_merchants
      end

      overpass_api_step.success!
      response
    rescue StandardError => e
      overpass_api_step.mark_as_fail(e)
      raise e
    end
  end

  def convert_to_geojson_step(response)
    convert_to_geojson_step = @merchant_sync.merchant_sync_steps.create!(step: :convert_to_geojson)

    begin
      geojson = JSONToGeoJSON.call(response.parsed_response)
      geojson_merchant_ids = geojson['features'].pluck('id')

      convert_to_geojson_step.success!
      [geojson, geojson_merchant_ids]
    rescue StandardError => e
      convert_to_geojson_step.mark_as_fail(e)
      raise e
    end
  end

  def save_data_step(geojson)
    save_data_step = @merchant_sync.merchant_sync_steps.create!(step: :save_data)

    begin
      upsert_merchants_to_database(geojson)
      save_data_step.success!
    rescue StandardError => e
      save_data_step.mark_as_fail(e)
      raise e
    end
  end

  def attach_json_step(geojson)
    attach_json_step = @merchant_sync.merchant_sync_steps.create!(step: :attach_json)

    begin
      @merchant_sync.raw_json.attach(
        io: StringIO.new(geojson.to_s),
        filename: "overpass_merchants_#{Time.current.to_fs(:number)}.json",
        content_type: 'application/json'
      )

      attach_json_step.success!
    rescue StandardError => e
      attach_json_step.mark_as_fail(e)
      raise e
    end
  end

  def notify_github_step(geojson_merchant_ids)
    notify_github_step = @merchant_sync.merchant_sync_steps.create!(step: :notify_github)

    begin
      I18n.with_locale(I18n.default_locale) do
        Merchants::CheckAndReportRemovedOnOSM.call(geojson_merchant_ids)
      end
      notify_github_step.success!
    rescue StandardError => e
      notify_github_step.mark_as_fail(e)
    end
  end

  def reactivate_disabled_step(geojson_merchant_ids)
    reactivate_disabled_step = @merchant_sync.merchant_sync_steps.create!(step: :reactivate_disabled)

    begin
      Merchants::CheckAndReactivate.call(geojson_merchant_ids)
      reactivate_disabled_step.success!
    rescue StandardError => e
      reactivate_disabled_step.mark_as_fail(e)
    end
  end

  def assign_country_step
    assign_country_step = @merchant_sync.merchant_sync_steps.create!(step: :assign_country)

    begin
      countries = Merchants::AssignCountry.call
      assign_country_step.success!
      countries
    rescue StandardError => e
      assign_country_step.mark_as_fail(e)
    end
  end

  def diff_change_step(payload_countries)
    diff_change_step = @merchant_sync.merchant_sync_steps.create!(step: :diff_change)

    begin
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

      diff_change_step.success!
    rescue StandardError => e
      diff_change_step.mark_as_fail(e)
    end
  end

  def purge_old_attachments_step
    purge_old_attachments_step = @merchant_sync.merchant_sync_steps.create!(step: :purge_old_attachments)

    begin
      @merchant_sync.purge_all_attachments_not_self
      purge_old_attachments_step.success!
    rescue StandardError => e
      purge_old_attachments_step.mark_as_fail(e)
    end
  end

  def publish_to_nostr_step
    publish_to_nostr_step = @merchant_sync.merchant_sync_steps.create!(step: :publish_to_nostr)

    begin
      I18n.with_locale(I18n.default_locale) do
        NostrPublisher.call(
          @merchant_sync, identifier: SecureRandom.uuid
        )
      end
      publish_to_nostr_step.success!
    rescue NostrErrors => e
      publish_to_nostr_step.mark_as_fail(e)
    end
  end

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
