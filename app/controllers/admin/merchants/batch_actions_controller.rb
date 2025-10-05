module Admin
  module Merchants
    class BatchActionsController < BaseController
      before_action :set_merchants, only: %i[update destroy]

      # @route PATCH /fr/admin/merchants/batch_actions {locale: "fr"} (admin_merchants_batch_actions_fr)
      # @route PATCH /es/admin/merchants/batch_actions {locale: "es"} (admin_merchants_batch_actions_es)
      # @route PATCH /de/admin/merchants/batch_actions {locale: "de"} (admin_merchants_batch_actions_de)
      # @route PATCH /it/admin/merchants/batch_actions {locale: "it"} (admin_merchants_batch_actions_it)
      # @route PATCH /en/admin/merchants/batch_actions {locale: "en"} (admin_merchants_batch_actions_en)
      # @route PATCH /admin/merchants/batch_actions
      # @route PUT /fr/admin/merchants/batch_actions {locale: "fr"} (admin_merchants_batch_actions_fr)
      # @route PUT /es/admin/merchants/batch_actions {locale: "es"} (admin_merchants_batch_actions_es)
      # @route PUT /de/admin/merchants/batch_actions {locale: "de"} (admin_merchants_batch_actions_de)
      # @route PUT /it/admin/merchants/batch_actions {locale: "it"} (admin_merchants_batch_actions_it)
      # @route PUT /en/admin/merchants/batch_actions {locale: "en"} (admin_merchants_batch_actions_en)
      # @route PUT /admin/merchants/batch_actions
      def update
        authorize! with: Admin::Merchants::BatchActionPolicy

        @merchants.update_all(deleted_at: nil)

        flash[:notice] = t('.notice')

        redirect_to admin_merchants_path(show_deleted: true)
      end

      # @route DELETE /fr/admin/merchants/batch_actions {locale: "fr"} (admin_merchants_batch_actions_fr)
      # @route DELETE /es/admin/merchants/batch_actions {locale: "es"} (admin_merchants_batch_actions_es)
      # @route DELETE /de/admin/merchants/batch_actions {locale: "de"} (admin_merchants_batch_actions_de)
      # @route DELETE /it/admin/merchants/batch_actions {locale: "it"} (admin_merchants_batch_actions_it)
      # @route DELETE /en/admin/merchants/batch_actions {locale: "en"} (admin_merchants_batch_actions_en)
      # @route DELETE /admin/merchants/batch_actions
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
