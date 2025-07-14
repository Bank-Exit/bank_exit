module Admin
  module Merchants
    class BatchActionsController < BaseController
      before_action :set_merchants, only: %i[update destroy]

      # @route PATCH /admin/merchants/batch_actions (admin_merchants_batch_actions)
      # @route PUT /admin/merchants/batch_actions (admin_merchants_batch_actions)
      def update
        authorize! with: Admin::Merchants::BatchActionPolicy

        @merchants.update_all(deleted_at: nil)

        flash[:notice] = t('.notice')

        redirect_to admin_merchants_path(show_deleted: true)
      end

      # @route DELETE /admin/merchants/batch_actions (admin_merchants_batch_actions)
      def destroy
        authorize! with: Admin::Merchants::BatchActionPolicy

        @merchants.destroy_all

        flash[:notice] = t('.notice')

        redirect_to admin_merchants_path(show_deleted: true)
      end

      private

      def merchant_params
        params.expect(batch_actions: :directory_ids)
      end

      def set_merchants
        @merchants = Merchant.includes(:comments).deleted.where(id: merchant_ids)
      end

      def merchant_ids
        merchant_params[:directory_ids].split(',')
      end
    end
  end
end
