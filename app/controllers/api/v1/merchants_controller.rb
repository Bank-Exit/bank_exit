module API
  module V1
    class MerchantsController < BaseController
      include Merchandable

      before_action :set_merchant, only: :show

      # @route GET /fr/api/v1/merchants {locale: "fr"} (api_v1_merchants_fr)
      # @route GET /es/api/v1/merchants {locale: "es"} (api_v1_merchants_es)
      # @route GET /de/api/v1/merchants {locale: "de"} (api_v1_merchants_de)
      # @route GET /it/api/v1/merchants {locale: "it"} (api_v1_merchants_it)
      # @route GET /en/api/v1/merchants {locale: "en"} (api_v1_merchants_en)
      # @route GET /api/v1/merchants
      def index
        pagy, page_ids = pagy_array(merchant_ids.ids)

        merchants = Merchant.where(id: page_ids).in_order_of(:id, page_ids)

        render_collection(merchants, pagy: pagy)
      end

      # @route GET /fr/api/v1/merchants/:id {locale: "fr"} (api_v1_merchant_fr)
      # @route GET /es/api/v1/merchants/:id {locale: "es"} (api_v1_merchant_es)
      # @route GET /de/api/v1/merchants/:id {locale: "de"} (api_v1_merchant_de)
      # @route GET /it/api/v1/merchants/:id {locale: "it"} (api_v1_merchant_it)
      # @route GET /en/api/v1/merchants/:id {locale: "en"} (api_v1_merchant_en)
      # @route GET /api/v1/merchants/:id
      def show
        render_resource(@merchant)
      end

      private

      def merchant_params
        params.permit(
          :country, :continent, :no_kyc, coins: []
        )
      end

      def set_merchant
        @merchant = Merchant.find_by!(identifier: merchant_id)
      end

      def merchant_id
        params[:id]
      end

      def coins
        @coins ||= merchant_params[:coins] || []
      end

      def country
        @country ||= merchant_params[:country]
      end

      def continent
        @continent ||= merchant_params[:continent]
      end

      def no_kyc?
        merchant_params[:no_kyc] == 'true'
      end
    end
  end
end
