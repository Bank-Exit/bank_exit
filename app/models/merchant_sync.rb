class MerchantSync < ApplicationRecord
  enum :mode, {
    sync: 0,
    clear: 1
  }

  enum :status, {
    pending: 0,
    success: 1,
    error: 2
  }, default: :pending,
     validate: true

  enum :instigator, {
    task: 0,
    manual: 1
  }, default: :task

  has_one_attached :raw_json

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
      broadcast_remove_to(
        %i[admin merchant_syncs],
        target: :process_logs_wrapper
      )
    end

    if status_previously_changed?
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          broadcast_admin_stats
          broadcast_admin_replace_table_row
        end
      end
    end

    broadcast_admin_replace_process_logs if process_logs_previously_changed? && pending?
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

  # This broadcast need to stay public to be manually
  # callable from inside a database transaction.
  def broadcast_admin_replace_process_logs
    broadcast_update_to(
      %i[admin merchant_syncs],
      target: :process_logs,
      partial: 'admin/merchant_syncs/process_logs',
      locals: { merchant_sync: self }
    )
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
end

# == Schema Information
#
# Table name: merchant_syncs
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
#
