module API
  module V1
    class DirectoriesController < BaseController
      before_action :set_directory, only: :show

      # @route GET /fr/api/v1/directories {locale: "fr"} (api_v1_directories_fr)
      # @route GET /es/api/v1/directories {locale: "es"} (api_v1_directories_es)
      # @route GET /de/api/v1/directories {locale: "de"} (api_v1_directories_de)
      # @route GET /it/api/v1/directories {locale: "it"} (api_v1_directories_it)
      # @route GET /en/api/v1/directories {locale: "en"} (api_v1_directories_en)
      # @route GET /api/v1/directories
      def index
        directories_filter = Directories::Filter.call(**directory_params)
        pagy, directories = pagy(directories_filter.by_position, limit: per_page)

        args = with_comments? ? { view: :with_comments } : {}

        render_collection(directories, pagy: pagy, **args)
      end

      # @route GET /fr/api/v1/directories/:id {locale: "fr"} (api_v1_directory_fr)
      # @route GET /es/api/v1/directories/:id {locale: "es"} (api_v1_directory_es)
      # @route GET /de/api/v1/directories/:id {locale: "de"} (api_v1_directory_de)
      # @route GET /it/api/v1/directories/:id {locale: "it"} (api_v1_directory_it)
      # @route GET /en/api/v1/directories/:id {locale: "en"} (api_v1_directory_en)
      # @route GET /api/v1/directories/:id
      def show
        args = with_comments? ? { view: :with_comments } : {}

        render_resource(@directory, **args)
      end

      private

      def directory_params
        params.permit(
          :per, :page,
          :query, :category, :city, :postcode,
          :department, :region, :country,
          :continent, :world,
          coins: []
        )
      end

      def set_directory
        @directory = Directory.find(params[:id])
      end

      def per
        directory_params[:per].to_i
      end
    end
  end
end
