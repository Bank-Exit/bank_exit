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
        pagy, page_ids = pagy_array(merchant_ids.ids, limit: per_page)

        merchants = Merchant.where(id: page_ids).in_order_of(:id, page_ids)

        args = with_comments? ? { view: :with_comments } : {}

        render_collection(merchants, pagy: pagy, **args)
      end

      # @route GET /fr/api/v1/merchants/:id {locale: "fr"} (api_v1_merchant_fr)
      # @route GET /es/api/v1/merchants/:id {locale: "es"} (api_v1_merchant_es)
      # @route GET /de/api/v1/merchants/:id {locale: "de"} (api_v1_merchant_de)
      # @route GET /it/api/v1/merchants/:id {locale: "it"} (api_v1_merchant_it)
      # @route GET /en/api/v1/merchants/:id {locale: "en"} (api_v1_merchant_en)
      # @route GET /api/v1/merchants/:id
      def show
        args = with_comments? ? { view: :with_comments } : {}

        render_resource(@merchant, **args)
      end

      private

      def merchant_params
        params.permit(
          :per, :page,
          :query, :category, :country, :continent,
          :with_atms, :no_kyc, coins: []
        )
      end

      def set_merchant
        @merchant = Merchant.find_by!(identifier: merchant_id)
      end

      def merchant_id
        params[:id]
      end

      def query
        @query ||= merchant_params[:query]
      end

      def category
        @category ||= merchant_params[:category]
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

      def with_atms?
        merchant_params[:with_atms]
      end

      def per
        merchant_params[:per].to_i
      end
    end
  end
end
