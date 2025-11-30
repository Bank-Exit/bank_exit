class MerchantSyncStep < ApplicationRecord
  enum :step, {
    init: 0,
    overpass_api: 1,
    convert_to_geojson: 2,
    save_data: 3,
    attach_json: 4,
    notify_github: 5,
    reactivate_disabled: 6,
    assign_country: 7,
    diff_change: 8,
    purge_old_attachments: 9,
    publish_to_nostr: 10,
    end_of_sync: 11,

    init_clear: 12,
    fetch_outdated: 13,
    clear_outdated: 14,
    end_of_clear: 15
  }, default: :init,
     validate: true

  enum :status, {
    pending: 0,
    success: 1,
    error: 2
  }, default: :pending,
     validate: true

  belongs_to :merchant_sync

  after_create_commit do
    broadcast_append_to(
      [:admin, :merchant_syncs, I18n.locale],
      target: "steps_for_merchant_sync_#{merchant_sync.id}"
    )
  end

  after_update_commit do
    broadcast_replace_to(
      [:admin, :merchant_syncs, I18n.locale]
    )

    merchant_sync.mark_as_success! if status_previously_changed?(from: :error, to: :success) && merchant_sync.merchant_sync_steps.all?(&:success?)
  end

  def mark_as_success!
    update!(
      status: :success,
      payload_error: {}
    )
  end

  def mark_as_fail(e)
    update(
      status: :error,
      payload_error: {
        exception: e.class.name,
        message: e.message,
        backtrace: e.backtrace
      }
    )
  end

  def message_for_step
    I18n.t(step, scope: 'merchant_sync_steps')
  end
end

# == Schema Information
#
# Table name: merchant_sync_steps
# Database name: primary
#
#  id               :integer          not null, primary key
#  step             :integer          default("init"), not null
#  status           :integer          default("pending"), not null
#  payload_error    :json             not null
#  merchant_sync_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_merchant_sync_steps_on_merchant_sync_id  (merchant_sync_id)
#
# Foreign Keys
#
#  merchant_sync_id  (merchant_sync_id => merchant_syncs.id)
#
