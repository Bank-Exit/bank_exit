require 'retry'

# This service is responsible to fetch merchants map data from
# the Overpass API.
class FetchMerchants < ApplicationService
  include Rails.application.routes.url_helpers

  RETRYABLE_ERRORS = [
    HTTParty::Error, Timeout, Net::HTTPGatewayTimeout
  ].freeze

  def call
    Merchant.transaction do
      backup_old_files_on_disk

      json = Retry.on(*RETRYABLE_ERRORS) do
        OverpassAPI.new.fetch_merchants
      end

      geojson = JSONToGeoJSON.call(json)
      @geojson_merchant_ids = geojson['features'].pluck('id')

      upsert_merchants_to_database(geojson)
      save_new_files_to_disk(json, geojson)

      remove_backup_files_from_disk
    end

    # Check and log removed merchants from OpenStreetMap that
    # are still present in Bank-Exit map.
    Merchants::CheckAndReportRemovedOnOSM.call(@geojson_merchant_ids)

    # Assign country to merchants that have nil value
    # Might take time at the first execution !
    Merchants::AssignCountry.call

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
  rescue StandardError => e
    restore_backup_files_on_disk

    Merchant.broadcast_flash(:alert, e.message)
  end

  private

  def backup_old_files_on_disk
    return unless File.exist?("#{files_folder_prefix}/export.json")

    # :nocov:
    File.rename("#{files_folder_prefix}/export.json", "#{files_folder_prefix}/export.backup.json")
    File.rename("#{files_folder_prefix}/export.geojson", "#{files_folder_prefix}/export.backup.geojson")
    File.rename("#{files_folder_prefix}/last_fetch_at.txt", "#{files_folder_prefix}/last_fetch_at.backup.txt")
    # :nocov:
  end

  def restore_backup_files_on_disk
    return unless File.exist?("#{files_folder_prefix}/export.backup.json")

    # :nocov:
    File.rename("#{files_folder_prefix}/export.backup.json", "#{files_folder_prefix}/export.json")
    File.rename("#{files_folder_prefix}/export.backup.geojson", "#{files_folder_prefix}/export.geojson")
    File.rename("#{files_folder_prefix}/last_fetch_at.backup.txt", "#{files_folder_prefix}/last_fetch_at.txt")
    # :nocov:
  end

  def remove_backup_files_from_disk
    return unless File.exist?("#{files_folder_prefix}/export.backup.json")

    # :nocov:
    File.delete("#{files_folder_prefix}/export.backup.json")
    File.delete("#{files_folder_prefix}/export.backup.geojson")
    File.delete("#{files_folder_prefix}/last_fetch_at.backup.txt")
    # :nocov:
  end

  def save_new_files_to_disk(json, geojson)
    timestamp = Time.parse(geojson['timestamp']).to_i

    File.write("#{files_folder_prefix}/last_fetch_at.txt", timestamp)
    File.write("#{files_folder_prefix}/export.json", JSON.pretty_generate(json.as_json))
    File.write("#{files_folder_prefix}/export.geojson", JSON.pretty_generate(geojson.as_json))
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
  def invalidate_cache
    merchants_cache = '%:MERCHANTS_FILTER:%'
    statistics_concern = "#{Rails.env}:concerns/statistics%"
    statistics_views = "#{Rails.env}:views/statistics%"

    records = SolidCache::Entry.where(
      'key LIKE ? OR key LIKE ? OR key LIKE ?',
      merchants_cache, statistics_concern, statistics_views
    )
    records.each(&:destroy)
  end
end
