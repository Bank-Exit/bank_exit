module Merchants
  class PopupsController < PublicController
    before_action :set_merchant
    skip_after_action :record_page_view

    # @route GET /fr/merchants/:merchant_id/popup {locale: "fr"} (merchant_popup_fr)
    # @route GET /es/merchants/:merchant_id/popup {locale: "es"} (merchant_popup_es)
    # @route GET /de/merchants/:merchant_id/popup {locale: "de"} (merchant_popup_de)
    # @route GET /it/merchants/:merchant_id/popup {locale: "it"} (merchant_popup_it)
    # @route GET /en/merchants/:merchant_id/popup {locale: "en"} (merchant_popup_en)
    # @route GET /merchants/:merchant_id/popup
    def show
      render layout: false
    end

    private

    def set_merchant
      @merchant = Merchant.find_by!(identifier: merchant_id).decorate
    end

    def merchant_id
      params[:merchant_id].split('-').first
    end
  end
end
