module Admin
  module Merchants
    class ReactivatesController < BaseController
      before_action :set_merchant, only: %i[create]

      # @route POST /admin/merchants/:merchant_id/reactivate (admin_merchant_reactivate)
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
