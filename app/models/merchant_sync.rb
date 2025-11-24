class MerchantSync < ApplicationRecord
  enum :mode, {
    sync: 0,
    clear: 1
  }

  enum :status, {
    pending: 0,
    success: 1,
    error: 2,
    success_with_error: 3
  }, default: :pending,
     validate: true

  enum :instigator, {
    task: 0,
    manual: 1
  }, default: :task

  has_many :merchant_sync_steps, dependent: :destroy
  has_one_attached :raw_json

  before_update :parse_json_strings

  after_create_commit do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        broadcast_admin_stats
        broadcast_admin_prepend_table_row
        broadcast_admin_remove_empty_table_row
      end
    end
  end

  after_update_commit do
    if status_previously_changed?
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          broadcast_admin_stats
          broadcast_admin_replace_table_row
        end
      end
    end
  end

  def self.by_query(query)
    ids = Set.new
    query = query.downcase

    payloads = %i[
      payload_added_merchants
      payload_before_updated_merchants
      payload_updated_merchants
      payload_soft_deleted_merchants
    ]

    all.select do |merchant_sync|
      payloads.each do |payload|
        ids << merchant_sync.id if merchant_sync.send(payload).to_s.downcase.include?(query)
      end
    end

    where(id: ids.to_a)
  end

  def mark_as_fail!
    update!(
      status: :error,
      ended_at: Time.current
    )
  end

  def with_details?
    !pending? && (
      added_merchants_count.positive? ||
      updated_merchants_count.positive? ||
      soft_deleted_merchants_count.positive?
    )
  end

  def purge_all_attachments_not_self
    MerchantSync.where.not(id: id)
                .includes(:raw_json_attachment)
                .where(active_storage_attachments: { name: 'raw_json' })
                .find_each do |record|
      record.raw_json.purge_later if record.raw_json.attached?
    end
  end

  def no_diff?
    payload_before_updated_merchants == payload_updated_merchants
  end

  private

  def broadcast_admin_stats
    broadcast_replace_to(
      stream_name,
      target: 'merchant_stats',
      partial: 'admin/merchants/stats',
      locals: {
        merchant_sync: self,
        dashboard_presenter: Admin::DashboardPresenter.new
      }
    )
  end

  def broadcast_admin_prepend_table_row
    broadcast_prepend_to(
      stream_name,
      partial: 'admin/merchant_syncs/merchant_sync'
    )
  end

  def broadcast_admin_replace_table_row
    broadcast_replace_to(
      [:admin, :merchant_syncs, I18n.locale],
      partial: 'admin/merchant_syncs/merchant_sync'
    )
  end

  def broadcast_admin_remove_empty_table_row
    broadcast_remove_to(
      stream_name,
      target: :merchant_syncs_empty
    )
  end

  def stream_name
    [:admin, :merchant_syncs, I18n.locale]
  end

  def parse_json_strings
    %i[
      payload_added_merchants
      payload_updated_merchants
      payload_soft_deleted_merchants
      payload_countries
      payload_nostr
    ].each do |field|
      value = send(field)
      next unless value.is_a?(String)

      begin
        send("#{field}=", JSON.parse(value))
      rescue JSON::ParserError
        errors.add(field, 'is not a valid JSON')
      end
    end
  end
end

# == Schema Information
#
# Table name: merchant_syncs
# Database name: primary
#
#  id                               :integer          not null, primary key
#  started_at                       :datetime
#  ended_at                         :datetime
#  mode                             :integer          default("sync"), not null
#  status                           :integer          default("pending"), not null
#  instigator                       :integer          default("task"), not null
#  added_merchants_count            :integer          default(0), not null
#  updated_merchants_count          :integer          default(0), not null
#  soft_deleted_merchants_count     :integer          default(0), not null
#  payload_added_merchants          :json             not null
#  payload_before_updated_merchants :json             not null
#  payload_updated_merchants        :json             not null
#  payload_soft_deleted_merchants   :json             not null
#  payload_countries                :json             not null
#  payload_error                    :json             not null
#  process_logs                     :json             not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  payload_nostr                    :json             not null
#  notes                            :text
#
