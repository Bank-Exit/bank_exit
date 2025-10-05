module Admin
  module Merchants
    class ReactivatesController < BaseController
      before_action :set_merchant, only: %i[create]

      # @route POST /fr/admin/merchants/:merchant_id/reactivate {locale: "fr"} (admin_merchant_reactivate_fr)
      # @route POST /es/admin/merchants/:merchant_id/reactivate {locale: "es"} (admin_merchant_reactivate_es)
      # @route POST /de/admin/merchants/:merchant_id/reactivate {locale: "de"} (admin_merchant_reactivate_de)
      # @route POST /it/admin/merchants/:merchant_id/reactivate {locale: "it"} (admin_merchant_reactivate_it)
      # @route POST /en/admin/merchants/:merchant_id/reactivate {locale: "en"} (admin_merchant_reactivate_en)
      # @route POST /admin/merchants/:merchant_id/reactivate
      def create
        authorize! @merchant, to: :reactivate?

        @merchant.undelete!

        flash[:notice] = t('.notice')

        redirect_back_or_to admin_merchants_path(show_deleted: true)
      end

      private

      def set_merchant
        @merchant = Merchant.find_by!(identifier: merchant_id)
      end

      def merchant_id
        params[:merchant_id].split('-').first
      end
    end
  end
end
