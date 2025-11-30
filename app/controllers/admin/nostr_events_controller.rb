module Admin
  class NostrEventsController < BaseController
    before_action :set_nostr_eventable

    # @route POST /fr/admin/merchant_syncs/:merchant_sync_id/nostr_events {locale: "fr"} (admin_merchant_sync_nostr_events_fr)
    # @route POST /es/admin/merchant_syncs/:merchant_sync_id/nostr_events {locale: "es"} (admin_merchant_sync_nostr_events_es)
    # @route POST /de/admin/merchant_syncs/:merchant_sync_id/nostr_events {locale: "de"} (admin_merchant_sync_nostr_events_de)
    # @route POST /it/admin/merchant_syncs/:merchant_sync_id/nostr_events {locale: "it"} (admin_merchant_sync_nostr_events_it)
    # @route POST /en/admin/merchant_syncs/:merchant_sync_id/nostr_events {locale: "en"} (admin_merchant_sync_nostr_events_en)
    # @route POST /admin/merchant_syncs/:merchant_sync_id/nostr_events
    def create
      authorize! @nostr_eventable, with: NostrEventPolicy

      @nostr_step = @nostr_eventable.merchant_sync_steps.find_or_create_by!(step: :publish_to_nostr)

      NostrPublisher.call(@nostr_eventable, identifier: SecureRandom.uuid)
      @nostr_step.mark_as_success!

      flash[:notice] = t('.notice')
      redirect_to admin_merchant_syncs_path
    rescue StandardError => e
      @nostr_step.mark_as_fail(e)

      flash[:alert] = e.message
      redirect_to admin_merchant_syncs_path
    end

    private

    def set_nostr_eventable
      @nostr_eventable = MerchantSync.find(params[:merchant_sync_id])
    end
  end
end
