module Admin
  module Merchants
    class DirectoryConvertersController < BaseController
      before_action :set_merchant, only: %i[create]

      # @route POST /fr/admin/merchants/:id/directory_converters {locale: "fr"} (admin_directory_converters_fr)
      # @route POST /es/admin/merchants/:id/directory_converters {locale: "es"} (admin_directory_converters_es)
      # @route POST /de/admin/merchants/:id/directory_converters {locale: "de"} (admin_directory_converters_de)
      # @route POST /it/admin/merchants/:id/directory_converters {locale: "it"} (admin_directory_converters_it)
      # @route POST /en/admin/merchants/:id/directory_converters {locale: "en"} (admin_directory_converters_en)
      # @route POST /admin/merchants/:id/directory_converters
      def create
        authorize! @merchant, with: DirectoryConverterPolicy

        @directory = @merchant.to_directory!

        flash[:notice] = t('.notice')

        redirect_to edit_admin_directory_path(@directory)
      end

      private

      def set_merchant
        @merchant = Merchant.find_by!(identifier: merchant_id)
      end

      def merchant_id
        params[:id].split('-').first
      end
    end
  end
end
